defmodule Taxi.Trip do
  @moduledoc """
  GenServer que representa un viaje en el sistema.
  Cada viaje es un proceso independiente que:
  - Mantiene el estado del viaje (abierto, aceptado, completado, expirado)
  - Maneja temporizadores para simulación y expiración
  - Notifica a cliente y conductor sobre eventos
  - Registra resultados en results.log
  """

  use GenServer
  require Logger

  @data_dir Application.compile_env(:proyecto_taxi, :data_dir, "data")
  @results_file Path.expand("results.log", @data_dir)
  @trip_timeout Application.compile_env(:proyecto_taxi, :trip_timeout, 20_000)
  @rewards Application.compile_env(:proyecto_taxi, :score_rewards, %{
    trip_completed_client: 10,
    trip_completed_driver: 15,
    trip_expired_penalty: -5
  })

  # state: %{id:, client:, origin:, destination:, driver: nil | driver, status: :open|:accepted|:completed|:expired, timer_ref: ref | nil}

  @doc """
  Inicia un nuevo proceso de viaje con:
  - Sesión del usuario solicitante
  - Sesión del conductor asignado
  - Ubicación de origen
  - Ubicación de destino

  Registra el proceso en el Registry y devuelve {:ok, pid}
  """
  def start_link(args) do
    Logger.info("[INFO] Starting new trip process")
    GenServer.start_link(__MODULE__, args)
  end

  @doc """
  Configura las opciones del proceso hijo para el supervisor.
  El modo :transient significa que:
  - El viaje se reiniciará si falla
  - No se reiniciará si termina normalmente (completado/expirado)
  """
  def child_spec(args) do
    %{
      id: {__MODULE__, args[:id] || :no_id},
      start: {__MODULE__, :start_link, [args]},
      restart: :transient,
      shutdown: 5_000,
      type: :worker
    }
  end

  @doc """
  Inicializa el estado del viaje:
  - Registra el viaje en TripRegistry
  - Configura un temporizador de expiración
  - Establece estado inicial (abierto, sin conductor)
  """
  def init(%{id: id} = state) do
    Logger.info("Starting trip #{id}")
    # register in Registry for listing
    Registry.register(Taxi.TripRegistry, id, self())
    # set a timeout to expire if not accepted
    ref = Process.send_after(self(), :expire, @trip_timeout)
    {:ok, Map.merge(state, %{driver: nil, status: :open, timer_ref: ref})}
  end

  @doc """
  Obtiene información del viaje a partir de su ID o PID.
  Devuelve un mapa con los detalles del viaje:
  - id: identificador único
  - client: usuario solicitante
  - origin: ubicación de origen
  - destination: ubicación destino
  - driver: conductor asignado (nil si no hay)
  - status: estado actual del viaje
  """
  def info(pid_or_id) do
    case pid_from(pid_or_id) do
      {:ok, pid} -> GenServer.call(pid, :info)
      err -> err
    end
  end

  @doc """
  Permite a un conductor aceptar un viaje dado su ID.
  Retorna:
  - {:ok, state} si el viaje fue aceptado exitosamente
  - {:error, :already_taken} si ya tiene conductor asignado
  - {:error, :not_found} si el viaje no existe
  """
  def accept(trip_id, driver) do
    case Registry.lookup(Taxi.TripRegistry, trip_id) do
      [{pid, _}] -> GenServer.call(pid, {:accept, driver})
      [] -> {:error, :not_found}
    end
  end

  @doc """
  Callback para solicitudes de información.
  Retorna un subconjunto del estado con los campos relevantes.
  """
  def handle_call(:info, _from, state) do
    {:reply, Map.take(state, [:id, :client, :origin, :destination, :driver, :status]), state}
  end

  @doc """
  Callback para aceptación de viaje:
  - Cancela temporizador de expiración
  - Inicia temporizador de finalización
  - Actualiza estado con conductor asignado
  - Notifica a cliente y conductor
  """
  def handle_call({:accept, driver}, _from, %{status: :open} = state) do
    # cancel expire timer
    if state.timer_ref, do: Process.cancel_timer(state.timer_ref)
    # start trip duration timer
    ref = Process.send_after(self(), :finish, @trip_timeout)
    state2 = %{state | driver: driver, status: :accepted, timer_ref: ref}
    # notify client that a driver accepted
    notify_user(state.client, "Driver #{driver} accepted trip #{state.id}. Trip will start now.\n")
    # notify driver that they accepted
    notify_user(driver, "You accepted trip #{state.id} for client #{state.client}. Trip will finish in #{div(@trip_timeout, 1000)} seconds.\n")
    Logger.info("Trip #{state.id} accepted by driver=#{driver} for client=#{state.client} from=#{state.origin} to=#{state.destination}")
    {:reply, {:ok, state2}, state2}
  end

  def handle_call({:accept, _driver}, _from, state) do
    {:reply, {:error, :already_taken}, state}
  end

  # Maneja la expiración de un viaje (cuando ningún conductor lo acepta)
  def handle_info(:expire, state) do
    # Registra el viaje como expirado
    log_result(state, "Expirado", state.client, "-")

    # Quita puntos al cliente por viaje expirado
    Taxi.UserManager.update_score(state.client, -5)

    # Avisa al cliente
    notify_user(state.client, "Trip #{state.id} expired. You lost 5 points.\n")

    # Termina el proceso
    {:stop, :normal, %{state | status: :expired}}
  end

  @doc """
  Callback para finalización de viaje:
  - Registra resultado como completado
  - Premia al cliente (+10) y conductor (+15)
  - Notifica a ambos usuarios
  - Detiene el proceso normalmente
  """
  def handle_info(:finish, state) do
    # trip completed
    log_result(state, "Completado", state.client, state.driver)
    client_reward = @rewards.trip_completed_client
    driver_reward = @rewards.trip_completed_driver

    Taxi.UserManager.update_score(state.client, client_reward)
    Taxi.UserManager.update_score(state.driver, driver_reward)

  # notify users of their rewards (use local notify_user helper)
  notify_user(state.client, "Trip #{state.id} completed. You gained +#{client_reward} points. Conductor=#{state.driver}.\n")
  notify_user(state.driver, "Trip #{state.id} completed. You gained +#{driver_reward} points. Cliente=#{state.client}.\n")
    Logger.info("Trip #{state.id} completed; client=#{state.client} driver=#{state.driver} origin=#{state.origin} destination=#{state.destination}")
    {:stop, :normal, %{state | status: :completed}}
  end

  @doc """
  Función auxiliar que obtiene el PID de un viaje.
  Acepta:
  - PID directo: lo retorna envuelto en {:ok, pid}
  - ID como string: busca el PID en el registro
  """
  defp pid_from(pid) when is_pid(pid), do: {:ok, pid}

  defp pid_from(id) when is_binary(id) do
    case Registry.lookup(Taxi.TripRegistry, id) do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, :not_found}
    end
  end

  # Guarda el resultado del viaje en el archivo results.log
  defp log_result(state, status, client, driver) do
    # Crea el directorio si no existe
    File.mkdir_p!(Path.dirname(@results_file))

    # Guarda fecha y datos del viaje
    fecha = DateTime.utc_now() |> DateTime.to_string()
    datos = [
      fecha,
      "cliente=#{client}",
      "conductor=#{driver}",
      "origen=#{state.origin}",
      "destino=#{state.destination}",
      "status=#{status}"
    ]

    # Escribe al archivo
    linea = Enum.join(datos, "; ")
    File.write!(@results_file, linea <> "\n", [:append])
  end

  # Envía un mensaje al usuario a través de su conexión TCP
  defp notify_user(username, message) do
    # Busca si el usuario tiene una sesión activa
    case Registry.lookup(Taxi.SessionRegistry, username) do
      [] ->
        :ok  # Usuario no conectado
      [{_pid, socket}] ->
        :gen_tcp.send(socket, message)  # Envía el mensaje
      _ ->
        :ok  # Ignora múltiples conexiones
    end
  end
end
