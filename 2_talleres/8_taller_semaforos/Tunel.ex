defmodule Tunel do
  def start(capacidad), do: spawn(fn -> loop(capacidad, capacidad, []) end)

  defp loop(cupos, total, dentro) do
    receive do
      {:entrar, n, e, pid} ->
        if cupos > 0 do
          nuevo = dentro ++ [{n, e}]
          mostrar("➡️ #{n} ENTRA al túnel", nuevo)
          send(pid, :ok)
          loop(cupos - 1, total, nuevo)
        else
          send(pid, :espera)
          loop(cupos, total, dentro)
        end

      {:salir, n, e} ->
        nuevo = List.delete(dentro, {n, e})
        mostrar("⬅️ #{n} SALE del túnel", nuevo)
        loop(cupos + 1, total, nuevo)
    end
  end

  defp mostrar(msg, dentro) do
    tunel =
      dentro
      |> Enum.map(fn {_n, e} -> e end)
      |> Enum.join(", ")
      |> then(fn s -> if s == "", do: "TUNEL []", else: "TUNEL [#{s}]" end)

    IO.puts("#{msg}. #{tunel}\n")
    :timer.sleep(1000)
  end
end
