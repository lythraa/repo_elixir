defmodule ContarPares do
  @doc """
  ejecuta el conteo de pares en una lista
  """
  def main do
    IO.puts("Pares en [1,2,3,4,6]: #{ContarPares.contar([1, 2, 3, 4, 6])}")
  end

  @doc """
  cuenta cuantos numeros pares hay en una lista usando recursividad
  """
  def contar([]), do: 0

  def contar([cabeza | cola]) do
    if rem(cabeza, 2) == 0 do # verificacmos si el numero es par
      1 + contar(cola) # si es par sumamos 1 y seguimos con la cola
    else
      contar(cola) # es como decir 0 + contar(cola)
    end
  end
end

ContarPares.main()
