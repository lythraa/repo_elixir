Code.require_file("Util.ex")

# Para este programa se tuvo en cuenta que en Colombia se trabajan 44 horas semanales, es decir, 176 horas al mes.

defmodule CalculoSalario do
  def main do
    nombre =
      "Ingrese el nombre del empleado: "
      |> Util.ingresar(:texto)

    salario_base =
      "Ingrese el salario base: "
      |> Util.ingresar(:real)

    horas_extras =
      "Ingrese las horas extras trabajadas: "
      |> Util.ingresar(:entero)

    salario_total = calcular_salario(salario_base, horas_extras)

    Util.mostrar_mensaje(
      "El salario total de #{nombre} es de $#{formatear_numero(salario_total)}."
    )
  end

  def calcular_salario(salario_base, horas_extras) do
    valor_hora = salario_base / 176
    salario_extras = horas_extras * valor_hora * 1.5
    salario_base + salario_extras
  end

  def formatear_numero(numero) do
  numero
  |> trunc()
  |> Integer.to_string()
  |> String.reverse()
  |> String.replace(~r/.{3}(?=.)/, "\\0,")
  |> String.reverse()
end
end

CalculoSalario.main()
