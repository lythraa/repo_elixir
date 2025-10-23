defmodule Cafeteria do
  def preparar_pedido() do
    jefe = self()  # ← proceso principal (el "jefe")

    # Proceso 1: preparar café
    spawn(fn ->
      :timer.sleep(1000)
      send(jefe, {:cafe, "Café listo ☕"})
    end)

    # Proceso 2: calentar pan
    spawn(fn ->
      :timer.sleep(1500)
      send(jefe, {:pan, "Pan caliente 🥐"})
    end)

    # Proceso 3: cobrar al cliente
    spawn(fn ->
      :timer.sleep(500)
      send(jefe, {:cobro, "Pago recibido 💰"})
    end)

    # Esperar los tres resultados
    recibir_respuestas(3)
  end

  # Función que espera N mensajes
  defp recibir_respuestas(0), do: IO.puts("✅ Pedido completado!")
  defp recibir_respuestas(n) do
    receive do
      msg ->
        IO.inspect(msg, label: "Recibido")
        recibir_respuestas(n - 1)
    end
  end
end

# Ejecutar:
Cafeteria.preparar_pedido()
