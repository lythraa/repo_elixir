Code.require_file("Util.ex")

defmodule ConversionTemperatura do
  def main do
    nombre = "Ingrese su nombre: "
    |> Util.ingresar(:texto)

    celsius = "Ingrese la temperatura en °C: "
    |> Util.ingresar(:real)

    fahrenheit = convertir_a_fahrenheit(celsius)
    kelvin = convertir_a_kelvin(celsius)

    Util.mostrar_mensaje(
      "#{nombre}, la temperatura es:\n" <>
      "- #{Float.round(fahrenheit, 1)} °F\n" <>
      "- #{Float.round(kelvin, 1)} K"
    )
  end

  def convertir_a_fahrenheit(celsius) do
    (celsius * 9 / 5) + 32
  end

  def convertir_a_kelvin(celsius) do
    celsius + 273.15
  end
end

ConversionTemperatura.main()
