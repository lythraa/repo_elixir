# Recibe los datos como argumentos desde Java
[nombre, horas_str, valor_str | _] = System.argv()

horas = String.to_integer(horas_str)
valor = String.to_integer(valor_str)

salario_base =
  if horas > 160 do
    160 * valor
  else
    horas * valor
  end

horas_extra =
  if horas > 160 do
    horas - 160
  else
    0
  end

salario_extra = horas_extra * valor * 1.25
salario_neto = salario_base + salario_extra

IO.puts("Empleado: #{nombre}\nSalario neto: $#{:erlang.float_to_binary(salario_neto, decimals: 2)}")
