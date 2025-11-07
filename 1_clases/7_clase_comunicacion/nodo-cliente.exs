defmodule Cliente do
  @servidor {:servidor, :'nodoservidor@servidor'}  # Cambia "servidor" si usas otro nombre

  def main() do
    IO.puts("[Cliente] Iniciando...")
    case Node.connect(:'nodoservidor@servidor') do
      true ->
        IO.puts("[Cliente] ✅ Conexión establecida.")
        enviar_mensajes()

      false ->
        IO.puts("[Cliente] ❌ No se pudo conectar al servidor.")
    end
  end

  defp enviar_mensajes() do
    msg = IO.gets("[Cliente] Escribe un mensaje (o 'salir' para terminar): ") |> String.trim()

    if msg == "salir" do
      IO.puts("[Cliente] Fin de la sesión.")
    else
      send(@servidor, {self(), msg})
      recibir_respuesta()
      enviar_mensajes()  # vuelve a preguntar
    end
  end

  defp recibir_respuesta() do
    receive do
      msg ->
        IO.puts("[Cliente] Respuesta: #{msg}")
    after
      3000 ->
        IO.puts("[Cliente] ⏱ No hubo respuesta del servidor.")
    end
  end
end

Cliente.main()
