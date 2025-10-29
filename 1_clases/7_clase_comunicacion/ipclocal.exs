defmodule IPClocal do
  def main do
    Util.mostrar_mensaje("--- PROCESO PRINCIPAL ---")

    crear_servicio()
    |> producir_elementos()

    recibir_respuestas
  end

  def producir_elementos(servicio) do
    {:mayusculas, "Juan"} |> enviar_mensaje(servicio)
    {:mayusculas, "María"} |> enviar_mensaje(servicio)
    {:minusculas, "PEDRO"} |> enviar_mensaje(servicio)
    {&String.reverse/1, "Juana"} |> enviar_mensaje(servicio)
  end

  defp crear_servicio(), do: spawn(IPClocal, :activar_servicio, [])
  defp enviar_mensaje(mensaje, servicio), do: send(sevicio({self(), mensaje}))

  def activar_servicio() do
    receive do
      {productor, :fin} ->
        send(productor, :fin)

      {productor, {:mayusculas, mensaje}} ->
        send(productor, String.upcase(mensaje))
        activar_servicio()

      {productor, {:minusculas, mensaje}} ->
        send(productor, String.downcase(mensaje))
        activar_servicio()

      {productor, {funcion, mensaje}} ->
        send(productor, funcion.(mensaje))
        activar_servicio()

      {productor, mensaje} ->
        send(productor, "El mensaje \"#{mensaje}\" es desconocido")
        activar_servicio()
    end
  end
end
