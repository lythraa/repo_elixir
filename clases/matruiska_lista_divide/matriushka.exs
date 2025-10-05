defmodule Matriushka do
    def main do
      numero =
        IO.gets("¿Cuántas muñecas quieres abrir? ")
        |> String.trim()
        |> String.to_integer()

      Matriushka.abrir(numero)
    end

  def abrir(0) do
    IO.puts(" :o ya no hay más muñecas !!!")
  end

  def abrir(n) do
    IO.puts("se abre #{n}")
    abrir(n - 1)
    IO.puts("se cierra #{n}")
  end
end

Matriushka.main()
