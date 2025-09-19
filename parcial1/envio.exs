Code.require_file("util.ex")

defmodule Envio do
  import Util

  @moduledoc """
  Programa que calcula cuánto cuesta enviar un paquete.
    - Pide el peso.
    - Pide el tipo de cliente (corporativo, estudiante o regular).
    - Pide el tipo de servicio (express o estándar).
    - Aplica tarifas, descuentos y recargos.
    - Muestra un resumen con todos los valores.
  """

  @doc """
  Inicia el programa:
    - Pide los datos del envío.
    - Calcula el costo.
    - Muestra los resultados.
  """
  def main do
    peso = ingresar("Ingrese el peso del paquete (kg): ", :real)

    tipo_cliente =
      ingresar("Tipo cliente (1=corporativo, 2=estudiante, 3=regular): ", :entero)
      |> case do
        1 -> :corporativo
        2 -> :estudiante
        3 -> :regular
        _ -> :regular
      end

    servicio =
      ingresar("Tipo de servicio (1=express, 2=estandar): ", :entero)
      |> case do
        1 -> :express
        2 -> :estandar
        _ -> :estandar
      end

    resultado = calcular_envio(peso, tipo_cliente, servicio)

    mostrar_mensaje("Base: #{real_a_string(resultado.base)}")
    mostrar_mensaje("Descuento: #{real_a_string(resultado.descuento)}")
    mostrar_mensaje("Subtotal: #{real_a_string(resultado.subtotal)}")
    mostrar_mensaje("Recargo: #{real_a_string(resultado.recargo)}")
    mostrar_mensaje("Total: #{real_a_string(resultado.total)}")
  end

  @doc """
  Calcula el costo de envío según:
    - peso (kg),
    - tipo de cliente,
    - tipo de servicio.

  Retorna un mapa con:
    - base: tarifa base
    - descuento: descuento según el cliente
    - subtotal: base - descuento
    - recargo: extra según el servicio
    - total: subtotal + recargo
  """
  def calcular_envio(peso, tipo_cliente, servicio) when peso > 0 do
    base = tarifa_base(peso)
    descuento = base * descuento_cliente(tipo_cliente)
    subtotal = base - descuento
    recargo = subtotal * recargo_servicio(servicio)
    total = subtotal + recargo

    %{
      base: base,
      descuento: descuento,
      subtotal: subtotal,
      recargo: recargo,
      total: total
    }
  end

  @doc """
  Tarifa base según el peso:
    - Hasta 1 kg → 8000
    - Hasta 5 kg → 12000
    - Más de 5 kg → 20000
  """
  def tarifa_base(peso) when peso <= 1, do: 8000.0
  def tarifa_base(peso) when peso <= 5, do: 12000.0
  def tarifa_base(_), do: 20000.0

  @doc """
  Descuento según el cliente:
    - corporativo → 15%
    - estudiante → 10%
    - regular → 0%
  """
  def descuento_cliente(:corporativo), do: 0.15
  def descuento_cliente(:estudiante), do: 0.10
  def descuento_cliente(:regular), do: 0.0

  @doc """
  Recargo según el servicio:
    - express → 25%
    - estándar → 0%
  """
  def recargo_servicio(:express), do: 0.25
  def recargo_servicio(:estandar), do: 0.0

  @doc """
  Convierte un número decimal a texto con 2 decimales.
  """
  def real_a_string(value) when is_float(value) do
    :erlang.float_to_binary(value, decimals: 2)
  end
end

Envio.main()
