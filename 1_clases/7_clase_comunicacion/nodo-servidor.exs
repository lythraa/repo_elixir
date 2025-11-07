defmodule Servidor do
  def main() do
    IO.puts("[Servidor] Esperando mensajes...")
    Process.register(self(), :servidor)
    escuchar()
  end

  defp escuchar() do
    receive do
      {from, msg} ->
        IO.puts("[Servidor] Recibí: #{msg}")
        send(from, "[Servidor] Mensaje recibido correctamente.")
        escuchar()
    end
  end
end

Servidor.main()
