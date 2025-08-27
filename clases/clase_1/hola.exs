Code.require_file("Util.exs")

defmodule Mensaje do
  @moduledoc """
Módulo para mostrar un mensaje de bienvenida en la consola.
- autor: leidy suarez
- fecha: 19/08/25
- licencia: GNU General Public License v3.0
"""
  def main do
    "Bienvenidos a la programación con Elixir"
    |> Util.mostrar_mensaje()
end
end

Mensaje.main()
