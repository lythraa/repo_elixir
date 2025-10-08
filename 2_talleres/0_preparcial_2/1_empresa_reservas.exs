Code.require_file("util.ex")
# preparcial 2 - Empresa de Reservas

defmodule Habitacion do
  @moduledoc """
  estructura para las habitaciones
  """
  defstruct numero: "", tipo: ""
end


defmodule Reserva do
  @moduledoc """
  estructura para las reservas, y metodos de la aplicacion
  """
  defstruct codigo: "",
            fecha_reserva: "",
            total: 0.0,
            fecha_entrada: "",
            cliente: "",
            habitaciones: []
  @doc """
  función principal para solicitar reservas usa el Util
  """
  def solicitar(mensaje, tipo) do
    Util.ingresar(mensaje, tipo)
  end

  @doc """
  función para solicitar las habitaciones
  """
  def solicitar_habitaciones() do
    num = solicitar("cuantas habitaciones desea registrar?: ", :entero)

    Enum.map(1..num, fn _ ->
      numero = solicitar("numero de habitación: ", :texto)
      tipo = solicitar("tipo de habitación (sencilla/doble): ", :texto)
      %Habitacion{numero: numero, tipo: tipo}
    end)
  end

  @doc """
  función para registrar una reserva
  """
  def registrar_reserva() do
    codigo = solicitar("codigo de reserva: ", :texto)
    fecha_reserva = solicitar("fecha de reserva: ", :texto)
    total = solicitar("total: ", :real)
    fecha_entrada = solicitar("fecha de entrada: ", :texto)
    cliente = solicitar("nombre del cliente: ", :texto)
    habitaciones = solicitar_habitaciones()

    %Reserva{
      codigo: codigo,
      fecha_reserva: fecha_reserva,
      total: total,
      fecha_entrada: fecha_entrada,
      cliente: cliente,
      habitaciones: habitaciones
    }
  end


  @doc """
  función para guardar una reserva en un archivo CSV
  """
  def guardar_reserva_csv(reserva, archivo) do
    encabezado = "codigo (codigo),fecha_reserva (fecha_reserva),total (total),fecha_entrada (fecha_entrada),cliente (cliente),habitaciones (habitaciones)\n"
    habitaciones = Enum.map(reserva.habitaciones, fn h -> "#{h.numero}-#{h.tipo}" end) |> Enum.join("|")
    contenido = "codigo (#{reserva.codigo}),fecha_reserva (#{reserva.fecha_reserva}),total (#{reserva.total}),fecha_entrada (#{reserva.fecha_entrada}),cliente (#{reserva.cliente}),habitaciones (#{habitaciones})\n"

    if File.exists?(archivo) do
      File.write(archivo, contenido, [:append])
    else
      File.write(archivo, encabezado <> contenido)
    end
  end

  @doc """
  función principal del programa
  """
  def main do
    Util.mostrar_mensaje("--- bienvenid@ al registro de reservaaa ---")
    reserva = registrar_reserva()
    guardar_reserva_csv(reserva, "reservas.csv")
    Util.mostrar_mensaje("reserva guardada en reservas.csv")
  end
end

Reserva.main()
