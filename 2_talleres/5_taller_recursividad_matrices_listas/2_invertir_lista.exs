defmodule InvertirLista do
  def main do
    lista = [1, 2, 3, 4]
    IO.puts("original: #{inspect(lista)}")
    IO.puts("invertida: #{inspect(invertir(lista))}")
  end

  @doc """
  invierte una lista recursivamente sin usar enum.reverse
  """
  def invertir([]), do: []
  def invertir([cabeza | cola]), do: invertir(cola) ++ [cabeza] #va colocando la cabeza al dinal
end

InvertirLista.main()
