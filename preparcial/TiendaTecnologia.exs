defmodule TiendaTecnologia do
  def main() do
    inventario = %{
      "tablet" => 100,
      "celular" => 30,
      "audifono" => 15
    }

    producto =
      IO.gets("Ingrese el producto a vender: ")
      |> String.trim()

    cantidad =
      IO.gets("Ingrese la cantidad a vender: ")
      |> String.trim()

    inventario_actualizado = actualizar_inventario(inventario, producto, String.to_integer(cantidad))

    IO.inspect(inventario_actualizado)
  end

  defp actualizar_inventario(inventario, producto, cantidad_vendida) do
    cond do
      not Map.has_key?(inventario, producto) ->
        IO.puts("El producto no existe en el inventario."); inventario

      cantidad_vendida > inventario[producto] ->
        IO.puts("No hay suficiente inventario para vender esa cantidad."); inventario

      true ->
        %{inventario | producto => inventario[producto] - cantidad_vendida}
    end
  end
end

TiendaTecnologia.main()
