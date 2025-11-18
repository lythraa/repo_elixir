defmodule Taxi.TripSupervisor do
  @moduledoc """
  Supervisor dinámico para procesos de viajes.

  Responsabilidades:
  - Supervisar procesos de viajes individuales
  - Reiniciar viajes que fallan inesperadamente
  - Permitir que viajes terminen normalmente
  - Mantener registro de viajes activos
  """

  use DynamicSupervisor

  @doc """
  Inicia el supervisor dinámico de viajes.
  Se registra con nombre global para ser accesible desde otros módulos.
  """
  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Inicializa el supervisor con estrategia one_for_one:
  - Cada viaje es independiente
  - Si un viaje falla, solo ese viaje se reinicia
  - No afecta a otros viajes en curso
  """
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Inicia un nuevo proceso de viaje supervisado.

  Parámetros:
  - args: Mapa con datos del viaje (id, cliente, origen, destino)

  Retorna:
  - {:ok, pid} si el viaje se inicia correctamente
  - {:error, reason} si hay algún problema
  """
  def start_trip(args) do
    spec = {Taxi.Trip, args}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
