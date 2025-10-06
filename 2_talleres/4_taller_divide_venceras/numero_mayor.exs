defmodule NumeroMayor do

  def main do
    #ejemplo
    lista = [1,5,4,10]
    mayor = obtener_mayor(lista)
    IO.puts(mayor)#10
  end

  def obtener_mayor([x]), do: x

  def obtener_mayor(lista) do
    {izquierda, derecha} = Enum.split(lista, div(length(lista), 2))
    mayor_izquierda = obtener_mayor(izquierda)
    mayor_derecha = obtener_mayor(derecha)
    max(mayor_izquierda, mayor_derecha)
  end

end

NumeroMayor.main()
