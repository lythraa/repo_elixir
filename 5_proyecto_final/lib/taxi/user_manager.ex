defmodule Taxi.UserManager do
  @moduledoc """
  Módulo para gestión de usuarios del sistema.
  Proporciona:
  - Registro y autenticación de usuarios
  - Gestión de roles (cliente/conductor)
  - Sistema de puntuación
  - Persistencia en users.dat

  Formato de archivo:
  username;role;password;score
  """

  use GenServer
  require Logger

  @data_dir Path.expand("data", File.cwd!())
  @users_file Path.join(@data_dir, "users.dat")

  # User format per line: username;role;password;score

  @doc """
  Inicia el servidor de gestión de usuarios.
  Se registra con nombre global para acceso desde otros módulos.
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Inicializa el estado del servidor:
  - Crea directorio de datos si no existe
  - Carga usuarios desde archivo
  - Inicializa estado con mapa de usuarios
  """
  def init(_state) do
    File.mkdir_p!(@data_dir)
    users = load_users()
    {:ok, %{users: users}}
  end

  # API Pública
  @doc """
  Conecta o registra un usuario en el sistema.
  Si el usuario no existe, lo registra automáticamente.
  Si existe, valida las credenciales.

  Parámetros:
  - username: nombre de usuario
  - password: contraseña
  - role: rol ("client" o "driver")

  Retorna:
  - {:ok, user} si la conexión es exitosa
  - {:error, :invalid_credentials} si la contraseña es incorrecta
  """
  def connect_user(username, password, role) do
    GenServer.call(__MODULE__, {:connect, username, password, role})
  end

  @doc """
  Obtiene información de un usuario por su nombre.
  Retorna nil si el usuario no existe.
  """
  def get_user(username) do
    GenServer.call(__MODULE__, {:get_user, username})
  end

  @doc """
  Actualiza la puntuación de un usuario.

  Parámetros:
  - username: nombre del usuario
  - delta: puntos a sumar o restar

  Retorna:
  - {:ok, updated_user} si la actualización es exitosa
  - {:error, :not_found} si el usuario no existe
  """
  def update_score(username, delta) do
    GenServer.call(__MODULE__, {:update_score, username, delta})
  end

  @doc """
  Retorna lista de todos los usuarios registrados
  en el sistema con sus datos completos.
  """
  def all_users() do
    GenServer.call(__MODULE__, :all_users)
  end

  # Callbacks
  @doc """
  Callback para conexión/registro de usuarios:
  - Si el usuario no existe: crea nuevo usuario
  - Si existe: valida contraseña
  - Persiste cambios si hay registro nuevo
  - Registra evento en el log
  """
  def handle_call({:connect, username, password, role}, _from, state) do
    users = state.users

    case Map.get(users, username) do
      nil ->
        # register automatically
        user = %{username: username, role: role, password: password, score: 0}
        users2 = Map.put(users, username, user)
        persist_users(users2)
        Logger.info("Registered user #{username} (#{role})")
        {:reply, {:ok, user}, %{state | users: users2}}

      %{password: pw} = user when pw == password ->
        {:reply, {:ok, user}, state}

      _ ->
        {:reply, {:error, :invalid_credentials}, state}
    end
  end

  def handle_call({:get_user, username}, _from, state) do
    {:reply, Map.get(state.users, username), state}
  end

  def handle_call({:update_score, username, delta}, _from, state) do
    users = state.users

    case Map.get(users, username) do
      nil ->
        {:reply, {:error, :not_found}, state}

      user ->
        new_user = Map.update!(user, :score, &(&1 + delta))
        users2 = Map.put(users, username, new_user)
        persist_users(users2)
        {:reply, {:ok, new_user}, %{state | users: users2}}
    end
  end

  def handle_call(:all_users, _from, state) do
    {:reply, Map.values(state.users), state}
  end

  # Funciones Auxiliares
  @doc """
  Carga usuarios desde archivo:
  - Lee users.dat línea por línea
  - Ignora líneas vacías y comentarios
  - Parsea formato username;role;password;score
  - Convierte a mapa de usuarios
  - Retorna mapa vacío si no existe archivo
  """
  defp load_users() do
    if File.exists?(@users_file) do
      @users_file
      |> File.stream!()
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn line -> line != "" and not String.starts_with?(line, "#") end)
      |> Enum.map(fn line ->
        case String.split(line, ";") do
          [username, role, password, score_s | _rest] ->
            score = case Integer.parse(score_s || "0") do
              {n, _} -> n
              :error -> 0
            end
            {username, %{username: username, role: role, password: password, score: score}}

          _ ->
            nil
        end
      end)
      |> Enum.filter(& &1)
      |> Enum.into(%{})
    else
      %{}
    end
  end

  @doc """
  Guarda usuarios en archivo:
  - Convierte mapa de usuarios a líneas de texto
  - Cada línea en formato username;role;password;score
  - Escribe al archivo users.dat
  - Asegura nueva línea al final
  """
  defp persist_users(map) do
    lines =
      map
      |> Map.values()
      |> Enum.map(fn %{username: u, role: r, password: p, score: s} ->
        Enum.join([u, r, p, Integer.to_string(s)], ";")
      end)

    File.write!(@users_file, Enum.join(lines, "\n") <> "\n")
  end
end
