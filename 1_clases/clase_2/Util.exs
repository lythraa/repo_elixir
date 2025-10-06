
defmodule Util do

  def mostrar_mensaje(mensaje) do
    System.cmd("java", ["UtilJava", mensaje])
  end

  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end

  def ingresar(mensaje, :real) do
    try do
      mensaje
      |> ingresar(:texto)
      |> String.to_float()
    rescue
      ArgumentError ->
        "Error: El valor ingresado no es un número real válido. Intente nuevamente."
        |> mostrar_mensaje()

        mensaje
        |> ingresar(:real)
    end
  end
    def ingresar(mensaje, :entero) do
    try do
      mensaje
      |> ingresar(:texto)
      |> String.to_integer()
    rescue
      ArgumentError ->
        "Error: El valor ingresado no es un número entero válido. Intente nuevamente."
        |> mostrar_mensaje()

        mensaje
        |> ingresar(:entero)
    end
  end
end
