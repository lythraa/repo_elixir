defmodule SumarMatriz do

  def main do
    matriz = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]

    IO.puts("suma total: #{sumar(matriz)}")
  end
  @doc """
  suma todos los elementos de una matriz (lista de listas) usando recursividad
  """
  def sumar([]), do: 0
  def sumar([fila | resto]), do: sumar_fila(fila) + sumar(resto)# suma la primera y luego suma el restoo

  def sumar_fila([]), do: 0
  def sumar_fila([cabeza | cola]), do: cabeza + sumar_fila(cola) # va sumando la cabeza y luego suma la cabeza de la cola hasta quedar vacia
end

SumarMatriz.main()
