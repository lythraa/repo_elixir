defmodule Drogueria do
  def main do
    ventas_diarias = %{
      1 => 100,
      2 => 300,
      3 => 200
    }

    analisis = analizar_ventas(ventas_diarias)
    IO.inspect(analisis)
  end

  defp analizar_ventas(ventas_diarias) do
    case ventas_diarias do
      %{} when map_size(ventas_diarias) == 0 ->
        {0, 0, "No hay datos"}

      _ ->
        total_ventas = Enum.reduce(ventas_diarias, 0, fn {_, ventas}, acc -> acc + ventas end)
        promedio_diario = total_ventas / map_size(ventas_diarias)

        {dia_mejor_venta,_} =
          Enum.max_by(ventas_diarias, fn {_, venta} -> venta end)

        analisis = {total_ventas, promedio_diario, dia_mejor_venta}
    end
  end
end

Drogueria.main()
