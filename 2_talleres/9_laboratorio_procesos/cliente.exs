# cliente.exs
# Ejecutar en la máquina cliente: iex --name nodocliente@IP_CLIENTE --cookie MI_COOKIE
defmodule Cliente do
  def iniciar(nodo_servidor_atom) do
    IO.puts("Cliente: intentando conectar al nodo #{inspect(nodo_servidor_atom)} ...")

    # intentar conectar al nodo remoto
    case Node.connect(nodo_servidor_atom) do
      true -> :ok
      false ->
        IO.puts("No se pudo conectar al nodo remoto. Revisa red/firewall y cookie.")
        :error
    end

    # pedir al nodo remoto el PID del proceso :servidor
    pid_servidor = :rpc.call(nodo_servidor_atom, Process, :whereis, [:servidor])

    if pid_servidor == nil do
      IO.puts("No se encontró el proceso :servidor en el nodo remoto.")
      :error
    else
      IO.puts("Conectado al servidor. PID remoto: #{inspect(pid_servidor)}")
      menu(pid_servidor, nodo_servidor_atom)
    end
  end

  defp menu(pid_servidor, _nodo_servidor_atom) do
    send(pid_servidor, {:listar_trabajos, self()})

    receive do
      {:respuesta_trabajos, trabajos} ->
        IO.puts("\n=== Trabajos disponibles ===")
        Enum.each(trabajos, fn t ->
          IO.puts("#{t.id}. #{t.titulo} (#{t.fecha})")
        end)

        IO.puts("\nElige un trabajo por ID o escribe su título exactamente:")
        entrada = IO.gets("> ") |> String.trim()

        # si la entrada es un número, la consideramos ID
        case Integer.parse(entrada) do
          {num, ""} ->
            send(pid_servidor, {:autores_de_trabajo_por_id, self(), num})
          :error ->
            send(pid_servidor, {:autores_de_trabajo_por_titulo, self(), entrada})
        end

        receive do
          {:respuesta_autores, autores} ->
            IO.puts("\n--- Autores del trabajo ---")
            Enum.each(autores, fn a ->
              IO.puts("#{a.nombre} #{a.apellido} - #{a.programa} (#{a.titulo}) - C.C. #{a.cedula}")
            end)

          {:error, msg} ->
            IO.puts("Error: #{msg}")
        after
          5000 ->
            IO.puts("No hubo respuesta dentro de 5s.")
        end

      {:error, msg} ->
        IO.puts("Error al solicitar trabajos: #{msg}")
    after
      5000 ->
        IO.puts("No hubo respuesta del servidor al pedir la lista de trabajos.")
    end
  end
end

# Para iniciar desde IEx: Cliente.iniciar(:'nodoservidor@IP_DEL_SERVIDOR')
