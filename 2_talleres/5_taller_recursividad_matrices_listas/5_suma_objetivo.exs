defmodule SumaObjetivo do
  def main do
    lista = [2, 4, 6, 3]
    objetivo = 9

    case encontrar_combinacion(lista, objetivo) do
      {:ok, combinacion} ->
        IO.puts("existe una combinación que suma #{objetivo}: #{inspect combinacion}")

      :no_existe ->
        IO.puts("no existe ninguna combinación que sume #{objetivo}")
    end
  end

  @doc """
  busca una combinación de elementos de la lista que sume exactamente el objetivo
  """

  def encontrar_combinacion([], 0), do: {:ok, []}
  #osea si al final despues de restar los numeros nos da 0,
  #     es que si existe la combinacion, si 5-2-3= 0, entonces 2+3=0

  def encontrar_combinacion([], _), do: :no_existe

  def encontrar_combinacion([cabeza | cola], objetivo) do
    # intentar incluir el número actual
    case encontrar_combinacion(cola, objetivo - cabeza) do
      {:ok, combinacion} ->
        # si encontramos una combinación válida, agregamos la cabeza
        {:ok, [cabeza | combinacion]}

      :no_existe ->
        # si no funcionó incluirlo, probamos sin incluirlo
        encontrar_combinacion(cola, objetivo)
    end
  end
end

SumaObjetivo.main()
