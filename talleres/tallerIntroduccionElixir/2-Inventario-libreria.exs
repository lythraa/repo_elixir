Code.require_file("Util.ex")

defmodule InventarioLibreria do
  def main do
    Util.mostrar_mensaje("Bienvenido al inventario de la libreria")
    titulo = "hola ingrese el titulo del libro: "
    |> Util.ingresar(:texto)
    unidades_disponibles = "ingrese las unidades disponibles: "
    |>Util.ingresar(:entero)
    precio = "ingrese el precio: "
    |>Util.ingresar(:real)
    precio = calcular_precios(unidades_disponibles, precio)
    mostrar_informacion(titulo, unidades_disponibles, precio)
  end
  def calcular_precios(unidades, precio) do
    unidades * precio


  end
  def mostrar_informacion(titulo, unidades_disponibles, precio) do
    Util.mostrar_mensaje("El libro #{titulo} tiene #{unidades_disponibles} unidades, con un valor total
 de $ #{precio}")

  end

end

InventarioLibreria.main()
