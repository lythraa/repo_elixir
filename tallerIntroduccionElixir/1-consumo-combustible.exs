Code.require_file("Util.ex")

defmodule ConsumoCombustible do
  def main do
    nombre = "Ingrese el nombre del conductor: "
    |> Util.ingresar(:texto)

    distancia = "Ingrese la distancia recorrida en kilómetros: "
    |> Util.ingresar(:real)

    litros = "Ingrese la cantidad de combustible consumido en litros: "
    |> Util.ingresar(:real)

    rendimiento = calcular_rendimiento(distancia, litros)

    Util.mostrar_mensaje(
      "El conductor #{nombre} recorrió #{Float.round(distancia, 2)} km " <>
      "consumiendo #{Float.round(litros, 2)} litros. " <>
      "Rendimiento: #{Float.round(rendimiento, 2)} km/L"
    )
  end

  def calcular_rendimiento(distancia, litros) do
    distancia / litros
  end
end

ConsumoCombustible.main()
