defmodule Util do
  @moduledoc """
  Módulo con funciones comunes
  - autor: leidy suarez
  - fecha: 26/08/2025
  - licencia:
  """

  @doc """
  Función para mostrar un mensaje en la consola
  """
  def mostrar_mensaje(mensaje) do
    mensaje
    |> IO.puts()
  end

  @doc """
  Función para mostrar un mensaje en PopUp
  """
  def mostrar_mensajeGUI(mensaje) do
    System.cmd("java", ["PopUp", mensaje])
  end

  @doc """
  Función para manejar el input de texto
  """
  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end

  def ingresar(numero, :entero) do
    try do
      numero
      |> ingresar(:texto)
      |> String.to_integer()
    rescue
      ArgumentError ->
        "Error, se espera que ingrese un número entero\n"
        |> mostrar_error()

        numero
        |> ingresar(:entero)
    end
  end

  def ingresar(numero, :real) do
    try do
      numero
      |> ingresar(:texto)
      |> String.to_float()
    rescue
      ArgumentError ->
        "Error, se espera que ingrese un número real\n"
        |> mostrar_error()

        numero
        |> ingresar(:real)
    end
  end

  def mostrar_error(mensaje) do
    IO.puts(:standard_error, mensaje)
  end

  @doc """
  Función para manejar el input de texto mediante interfaz gráfica
  """
  def ingresarGUI(mensaje,:texto) do
    # Llama al programa Java para ingresar texto y capturar la entrada
    case System.cmd("java", ["-cp", ".", "Mensaje","input", mensaje]) do
    {output, 0} ->
    IO.puts("Texto ingresado correctamente.")
    IO.puts("Entrada: #{output}")
    String.trim(output) # Retorna la entrada sin espacios extra
    {error, code} ->
    IO.puts("Error al ingresar el texto. Código: #{code}")
    IO.puts("Detalles: #{error}")
    nil
    end
  end

end
