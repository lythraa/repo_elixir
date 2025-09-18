Code.require_file("Util.ex")
defmodule VehiculosPeaje do

  def main do
    mensaje = "Ingrese la placa del vehiculo"
    |> Util.ingresar(:texto)
    tipo = "Ingrese el tipo de vehiculo (Carro, Moto, Camion): "
    |> Util.ingresar(:texto)
    peso = "Ingrese el peso del vehiculo en toneladas: "
    |> Util.ingresar(:real)
    tarifa = calcular_tarifa(tipo, peso)
    tupla_info = {tipo, peso, tarifa}
    generar_tupla_mensaje(tupla_info)
    |> Util.mostrar_mensaje()
  end

  def calcular_tarifa do


  end

  def generar_tupla_mensaje() do
    

  end

end
