defmodule EcoMensajeScript do
  def main do
    mensaje = System.argv()
    |> Enum.join(" ")
    IO.puts String.upcase(mensaje)
  end
end

EcoMensajeScript.main()
