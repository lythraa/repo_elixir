defmodule Main do
  def run do
    matriz = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]

    # t1 (S1)
    t1 = Task.async(fn -> Laboratorio.suma_bajo_diagonal(matriz) end)

    # t2 (S2)
    t2 = Task.async(fn -> Laboratorio.promedio_encima_diagonal(matriz) end)

    # Esperar resultados
    a = Task.await(t1)
    b = Task.await(t2)

    # S3: c = a * b
    c = a * b

    # S4: imprimir c
    IO.puts("El resultado de la suma debajo de la diagonal principal es: #{a}")
    IO.puts("El promedio de los elementos encima de la diagonal principal es: #{b}")
    IO.puts("El resultado de a * b es: #{c}")
  end
end

# Procesos S1 y S2
defmodule Laboratorio do
  # S1: suma de los números debajo de la diagonal principal (recursivo)
  def suma_bajo_diagonal(matriz) do
    suma_bajo_diagonal(matriz, 0, 0)
  end

  defp suma_bajo_diagonal([], _fila, suma), do: suma

  defp suma_bajo_diagonal([fila | resto], fila_idx, acc) do
    suma_fila =
      fila
      |> Enum.take(fila_idx)
      |> Enum.sum()

    suma_bajo_diagonal(resto, fila_idx + 1, acc + suma_fila)
  end

  # S2: promedio de los elementos encima de la diagonal principal
  def promedio_encima_diagonal(matriz) do
    {suma, conteo} = recorrer_encima_diagonal(matriz, 0, {0, 0})
    if conteo == 0, do: 0, else: suma / conteo
  end

  defp recorrer_encima_diagonal([], _, acc), do: acc

  defp recorrer_encima_diagonal([fila | resto], fila_idx, {suma, conteo}) do
    elementos = Enum.drop(fila, fila_idx + 1)
    nuevos = Enum.sum(elementos)
    recorrer_encima_diagonal(resto, fila_idx + 1, {suma + nuevos, conteo + length(elementos)})
  end
end

Main.run()
