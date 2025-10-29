defmodule Util do
  @doc """
  Muestra un mensaje en consola.
  Recibe un texto y lo imprime en pantalla.
  """
  def mostrar_mensaje(mensaje) do
    mensaje
    |> IO.puts()
  end

  @doc """
  Solicita y lee una entrada desde la consola.
  Dependiendo del tipo especificado, convierte la entrada a:
  - :texto: cadena de texto
  - :real: número de punto flotante
  - :entero: número entero
  - :boolean: valor booleano (true/false)
  """
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

  def ingresar(mensaje, :boolean) do
    valor =
      mensaje
      |> ingresar(:texto)
      |> String.downcase()

    Enum.member?(["s", "si", "true", "sí"], valor)
  end
end
