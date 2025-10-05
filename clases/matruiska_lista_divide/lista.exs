defmodule DivideVenceras do
  def main do
    numeros = [1, 2, 3, 4, 5, 6, 7]
    IO.puts("La suma es: #{DivideVenceras.recorrer(numeros)}")
  end

  # caso base: lista vacía
  def recorrer([]), do: 0

  # caso base: lista de 1 elemento
  def recorrer([x]), do: x

  # caso general
  def recorrer(lista) do
    {izq, der} = Enum.split(lista, div(length(lista), 2))
    # resolver mitades y sumar
    recorrer(izq) + recorrer(der)
  end
end

DivideVenceras.main()
