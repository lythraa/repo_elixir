defmodule NReinas do
  def main do
    IO.puts("Ingrese el número de reinas (n):")
    n = String.to_integer(String.trim(IO.gets("> ")))
    resolver(n)
  end

  def resolver(n) do
    soluciones = colocar_reina(n, 0, [])
    IO.puts("\nSe encontraron #{length(soluciones)} soluciones:\n")
    Enum.each(soluciones, &imprimir_tablero(&1, n))
  end

  # Si llegamos a la última fila, devolvemos la solución encontrada
  defp colocar_reina(n, fila, posiciones) when fila == n, do: [Enum.reverse(posiciones)]

  # Intentamos colocar una reina en cada columna de la fila actual
  defp colocar_reina(n, fila, posiciones) do
    # Recorremos todas las columnas posibles de la fila actual.
    for columna <- 0..(n - 1),
        # Solo continúa si es seguro poner la reina ahí
        es_seguro?(fila, columna, posiciones),
        # si fue seguro colocamos la reina y avanzamos a la siguiente fila
        solucion <- colocar_reina(n, fila + 1, [{fila, columna} | posiciones]),
        # el for genera una lista con todas las soluciones posibles
        do: solucion
  end

  # comprueba si es seguro poner una reina en (fila, columna)

  defp es_seguro?(_fila, _columna, []), do: true

  # Si ya hay reinas, revisamos una por una
  defp es_seguro?(fila, columna, [{f, c} | resto]) do
    # Si están en la misma columna → no es seguro
    # Si están en la misma diagonal → no es seguro
    if c == columna or
         abs(f - fila) == abs(c - columna) do
      false
    else
      # Si no hay conflicto, seguimos revisando las demás reinas
      es_seguro?(fila, columna, resto)
    end
  end

  # Imprimir el tablero con las reinas colocadas

  defp imprimir_tablero(posiciones, n) do
    # Recorremos cada fila del tablero
    Enum.each(0..(n - 1), fn fila ->
      # Recorremos cada columna dentro de esa fila
      Enum.each(0..(n - 1), fn columna ->
        if {fila, columna} in posiciones do
          IO.write(" Q ")
        else
          IO.write(" . ")
        end
      end)

      IO.puts("")
    end)

    IO.puts("\n----------------------------\n")
  end
end

NReinas.main()
