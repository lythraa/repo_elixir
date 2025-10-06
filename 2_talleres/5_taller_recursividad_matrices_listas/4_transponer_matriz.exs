defmodule TransponerMatriz do
  def main do
    matriz = [
      [1, 2, 3],
      [4, 5, 6]
    ]

    IO.puts("transpuesta:")
    IO.inspect(transponer(matriz))
  end

  @doc """
  transpone una matriz (convierte filas en columnas) usando recursividad.
  """
  def transponer([]), do: []
  def transponer([[] | _]), do: []

  def transponer(matriz) do
    primera_columna = for [columna | _] <- matriz, do: columna # toma la primera columna
    resto_matriz = for [_ | resto_colummnas] <- matriz, do: resto_colummnas # toma el resto de la matriz
    [primera_columna | transponer(resto_matriz)]
  end
end

TransponerMatriz.main()
