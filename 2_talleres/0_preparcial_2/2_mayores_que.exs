Code.require_file("util.ex")
# preparcial 2 - Contar Mayores

defmodule ContarMayores do
  @moduledoc """
  módulo para contar elementos mayores que un número dado en una lista
  """
  def main do
    lista = [34, 67, 89, 23, 90, 12, 45, 78, 99, 21]
    numero = 68
    resultado = contar_mayores(lista, numero)
    Util.mostrar_mensaje("Hay #{resultado} elementos mayores que #{numero}")
  end

  @doc """
  función recursiva para contar elementos mayores que un número dado
  """
  def contar_mayores([], _numero), do: 0

  def contar_mayores([cabeza | cola], numero) do
    if cabeza > numero do
      1 + contar_mayores(cola, numero)
    else
      contar_mayores(cola, numero)
    end
  end
end

ContarMayores.main()
