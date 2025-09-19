Code.require_file("util.ex")

defmodule Salas do
  import Util

  @moduledoc """
  Programa para manejar reservas de sillas en salas de cine/teatro.

  Qué hace:
    - Cada sala tiene un número de sillas.
    - El usuario elige la sala y cuántas sillas quiere reservar.
    - Se revisa si la sala existe y si hay sillas suficientes.
    - Si todo está bien, se actualizan las sillas disponibles.
  """

  @doc """
  Inicia el programa:
    - Muestra las salas y sus sillas.
    - Pide número de sala y cantidad de sillas.
    - Intenta hacer la reserva.
    - Muestra si fue exitosa o no.
  """
  def main do
    # Salas con sillas iniciales
    salas = %{
      1 => 100,
      2 => 50,
      3 => 80
    }

    num_sala = ingresar("Ingrese número de sala: ", :entero)
    cantidad = ingresar("Ingrese cantidad de sillas a reservar: ", :entero)

    case reservar_sillas(salas, num_sala, cantidad) do
      {:ok, salas_actualizadas} ->
        mostrar_mensaje("Reserva exitosa! Salas ahora: #{inspect(salas_actualizadas)}")

      {:error, msg} ->
        mostrar_mensaje("Error: #{msg}")
    end
  end

  @doc """
  Reserva sillas en una sala.

  Parámetros:
    - salas: mapa con salas y sillas disponibles.
    - num_sala: sala elegida.
    - cantidad: sillas a reservar.

  Retorna:
    - {:ok, salas_actualizadas} si se pudo reservar.
    - {:error, "mensaje"} si no existe la sala o no hay suficientes sillas.
  """
  def reservar_sillas(salas, num_sala, cantidad) do
    case Map.get(salas, num_sala) do
      nil ->
        {:error, "Sala no encontrada"}

      disponibles when disponibles < cantidad ->
        {:error, "No hay suficientes sillas disponibles"}

      disponibles ->
        {:ok, Map.put(salas, num_sala, disponibles - cantidad)}
    end
  end
end

Salas.main()
