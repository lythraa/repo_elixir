defmodule Taxi.Server do
  @moduledoc """
  Servidor TCP que maneja las conexiones de clientes y conductores.
  Proporciona una interfaz CLI para:
  - Autenticación de usuarios
  - Solicitud y gestión de viajes
  - Consulta de puntuaciones y ranking
  - Notificaciones en tiempo real
  """

  use GenServer
  require Logger

  @port Application.compile_env(:proyecto_taxi, :tcp_port, 4040)

  @doc """
  Inicia el servidor TCP en el puerto configurado.
  El servidor se registra con un nombre global para ser accesible.
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Inicializa el servidor:
  - Crea socket de escucha en puerto @port
  - Inicia bucle de aceptación de conexiones
  - Almacena el socket en el estado
  """
  def init(state) do
  {:ok, listener} = :gen_tcp.listen(@port, [:binary, packet: :line, active: false, reuseaddr: true])
  # Use inspect to avoid Protocol.UndefinedError if a config value is a tuple (e.g. tcp_host)
  Logger.info("Taxi server listening on port #{inspect(@port)}")
    # accept loop
    Task.start(fn -> accept_loop(listener) end)
    {:ok, Map.put(state, :listener, listener)}
  end

  # Acepta nuevas conexiones de forma continua
  defp accept_loop(listener) do
    {:ok, socket} = :gen_tcp.accept(listener)
    # Inicia un proceso para manejar al cliente
    Task.Supervisor.start_child(Taxi.TaskSupervisor, fn -> handle_client(socket) end)
    accept_loop(listener)
  end

  @doc """
  Maneja la conexión individual de un cliente:
  - Envía mensaje de bienvenida
  - Inicia bucle de procesamiento de comandos
  """
  defp handle_client(socket) do
    :gen_tcp.send(socket, "Welcome to Taxi CLI server. Type 'help' for commands.\n")
    loop(%{socket: socket, user: nil})
  end

  @doc """
  Bucle principal de comunicación con cliente:
  - Lee línea de comando del socket
  - Procesa el comando y actualiza estado
  - Maneja desconexión del cliente
  - Continúa procesando más comandos
  """
  defp loop(state) do
    socket = state.socket
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        line = String.trim(data)
        new_state = handle_line(line, state)
        loop(new_state)

      {:error, :closed} ->
        if state.user do
          :ok
        end
        :ok
    end
  end

  # Manejadores de comandos
  @doc """
  Maneja línea vacía - no hace nada
  """
  defp handle_line(<<>>, state), do: state

  @doc """
  Comando: help
  Muestra lista de comandos disponibles con su sintaxis
  """
  defp handle_line("help", state) do
    write(state.socket, "Commands:\n connect username password role(client|driver)\n disconnect\n request_trip origen=ORIGEN destino=DESTINO\n list_trips\n accept_trip TRIP_ID\n score\n ranking\n help\n")
    state
  end

  @doc """
  Comando: connect username password role
  Autentica al usuario y registra su sesión para notificaciones.
  Roles permitidos: client, driver
  """
  defp handle_line(<<"connect ", rest::binary>>, state) do
    parts = String.split(rest)
    case parts do
      [username, password, role] when role in ["client", "driver"] ->
        case Taxi.UserManager.connect_user(username, password, role) do
          {:ok, user} ->
              # register session (store socket as the value)
              Registry.register(Taxi.SessionRegistry, username, state.socket)
              write(state.socket, "Connected as #{username} (#{role})\n")
              Logger.info("User connected: #{username} (#{role})")
              %{state | user: user}

          {:error, _} ->
            write(state.socket, "Login failed\n")
            state
        end

      _ ->
        write(state.socket, "Invalid connect. Usage: connect username password role\n")
        state
    end
  end

  @doc """
  Comando: disconnect
  Cierra la conexión TCP del cliente
  """
  defp handle_line("disconnect", state) do
    write(state.socket, "Goodbye\n")
    :gen_tcp.close(state.socket)
    state
  end

  @doc """
  Comando: request_trip origen=ORIGEN destino=DESTINO
  Permite a un cliente solicitar un nuevo viaje:
  - Valida que sea un cliente autenticado
  - Verifica ubicaciones origen/destino válidas
  - Crea nuevo proceso de viaje supervisado
  """
  defp handle_line(<<"request_trip ", rest::binary>>, state) do
    if state.user == nil or state.user.role != "client" do
      write(state.socket, "Only connected clients can request trips.\n")
      state
    else
      params = parse_params(rest)
      origin = Map.get(params, "origen")
      dest = Map.get(params, "destino")
      if origin && dest && Taxi.Location.valid_location?(origin) && Taxi.Location.valid_location?(dest) do
        id = "trip#{:erlang.unique_integer([:positive])}"
        args = %{id: id, client: state.user.username, origin: origin, destination: dest}
        {:ok, _pid} = Taxi.TripSupervisor.start_trip(args)
        write(state.socket, "Trip created: #{id}\n")
        state
      else
        write(state.socket, "Invalid or missing origin/destination. Check locations.\n")
        state
      end
    end
  end

  @doc """
  Comando: list_trips
  Muestra a los conductores los viajes disponibles:
  - Verifica que sea un conductor autenticado
  - Lista todos los viajes del Registry
  - Muestra detalles de origen, destino y estado
  - Filtra viajes no válidos o expirados
  """
  defp handle_line("list_trips", state) do
    if state.user == nil or state.user.role != "driver" do
      write(state.socket, "Only drivers can list trips.\n")
      state
    else
      # Obtiene lista simple de IDs de viajes
      trip_ids = Registry.select(Taxi.TripRegistry, [{{:"$1", :_, :_}, [], [:"$1"]}])

      # Obtiene info de cada viaje activo
      trips = Enum.map(trip_ids, fn id -> Taxi.Trip.info(id) end)
      |> Enum.filter(fn info -> info != nil and info != {:error, :not_found} end)

      if trips == [] do
        write(state.socket, "No trips available.\n")
      else
        Enum.each(trips, fn t ->
          write(state.socket, "#{t.id} - #{t.client} from #{t.origin} to #{t.destination} status=#{t.status}\n")
        end)
      end
      state
    end
  end

  @doc """
  Comando: accept_trip TRIP_ID
  Permite a un conductor aceptar un viaje:
  - Verifica que sea un conductor autenticado
  - Valida existencia del viaje
  - Confirma que el viaje esté disponible
  - Asigna el conductor al viaje
  - Notifica resultado de la operación
  """
  defp handle_line(<<"accept_trip ", trip_id::binary>>, state) do
    if state.user == nil or state.user.role != "driver" do
      write(state.socket, "Only drivers can accept trips.\n")
      state
    else
      trip_id = String.trim(trip_id)
      case Taxi.Trip.accept(trip_id, state.user.username) do
        {:ok, _} -> write(state.socket, "Accepted #{trip_id}\n")
        {:error, :not_found} -> write(state.socket, "Trip not found\n")
        {:error, :already_taken} -> write(state.socket, "Trip already taken\n")
        _ -> write(state.socket, "Error accepting trip\n")
      end
      state
    end
  end

  @doc """
  Comando: score
  Muestra la puntuación actual del usuario:
  - Verifica que el usuario esté conectado
  - Consulta puntuación en UserManager
  - Muestra puntos acumulados
  """
  defp handle_line("score", state) do
    if state.user == nil do
      write(state.socket, "Not connected\n")
      state
    else
      case Taxi.UserManager.get_user(state.user.username) do
        nil -> write(state.socket, "User not found\n"); state
        user -> write(state.socket, "Your score: #{user.score}\n"); state
      end
    end
  end

  @doc """
  Comando: ranking
  Muestra clasificación de todos los usuarios:
  - Lista usuarios ordenados por puntuación
  - Muestra rol y puntos de cada uno
  """
  defp handle_line("ranking", state) do
    users = Taxi.UserManager.all_users()
    sorted = Enum.sort_by(users, & &1.score, :desc)
    Enum.each(sorted, fn u -> write(state.socket, "#{u.username} (#{u.role}) - #{u.score}\n") end)
    state
  end

  defp handle_line(_other, state) do
    write(state.socket, "Unknown command. Type 'help' for commands.\n")
    state
  end

  @doc """
  Función auxiliar para parsear parámetros:
  Convierte string "param1=valor1 param2=valor2"
  en mapa %{"param1" => "valor1", "param2" => "valor2"}
  """
  # Convierte "origen=A destino=B" en %{"origen" => "A", "destino" => "B"}
  defp parse_params(texto) do
    params = %{}
    # Divide por espacios y procesa cada parte
    partes = String.split(texto)
    Enum.reduce(partes, params, fn parte, acc ->
      case String.split(parte, "=") do
        [key, value] -> Map.put(acc, key, value)
        _ -> acc
      end
    end)
  end

  @doc """
  Función auxiliar para enviar mensaje por socket.
  Envuelve :gen_tcp.send para manejo consistente.
  """
  defp write(socket, msg) do
    :gen_tcp.send(socket, msg)
  end
end
