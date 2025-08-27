Code.require_file("Util.exs")

defmodule EntradaDatos do
  def main do
    "Ingresar nombre de empleado: "
    |> Util.ingresar(:texto)
    |> generar_mensaje()
    |> Util.mostrar_mensaje()
  end

  defp generar_mensaje(nombre) do
    "bienvenido empleado: #{nombre}"
  end
end

EntradaDatos.main()
