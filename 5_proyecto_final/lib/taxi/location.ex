defmodule Taxi.Location do
  @moduledoc """
  Módulo para gestionar ubicaciones válidas en el sistema.
  Proporciona:
  - Carga de ubicaciones desde archivo
  - Validación de ubicaciones
  - Lista de ubicaciones predeterminadas
  - Persistencia en locations.dat
  """

  use GenServer
  require Logger

  @data_dir Path.expand("data", File.cwd!())
  @locations_file Path.join(@data_dir, "locations.dat")

  @doc """
  Inicia el servidor de ubicaciones.
  Se registra con nombre global para fácil acceso.
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Inicializa el estado del servidor:
  - Crea directorio de datos si no existe
  - Carga lista de ubicaciones del archivo
  - Usa ubicaciones predeterminadas si no hay archivo
  """
  def init(_state) do
    File.mkdir_p!(@data_dir)
    locations = load_locations()
    {:ok, %{locations: locations}}
  end

  @doc """
  Retorna lista de todas las ubicaciones válidas
  disponibles en el sistema.
  """
  def all() do
    GenServer.call(__MODULE__, :all)
  end

  @doc """
  Verifica si una ubicación dada es válida.
  Retorna true si existe en la lista de ubicaciones.
  """
  def valid_location?(loc) do
    loc in all()
  end

  @doc """
  Callback que retorna todas las ubicaciones
  almacenadas en el estado del servidor.
  """
  def handle_call(:all, _from, state) do
    {:reply, state.locations, state}
  end

  @doc """
  Función auxiliar para cargar ubicaciones:
  - Lee archivo locations.dat si existe
  - Filtra líneas vacías
  - Usa lista predeterminada si no hay archivo
  """
  defp load_locations() do
    if File.exists?(@locations_file) do
      @locations_file
      |> File.stream!()
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(&1 != ""))
    else
      # default locations
      ["Parque", "Centro", "Estacion", "Aeropuerto", "Plaza"]
    end
  end
end
