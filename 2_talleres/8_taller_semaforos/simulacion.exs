defmodule Simulacion do
  def run do
    tunel = Tunel.start(2)

    IO.puts("\n🚦 ¡Inicia la simulación del túnel!\n")

    vehiculos = [
      {"Spark", "🚗", 7000},
      {"Toyota", "🚙", 9000},
      {"Taxi", "🚕", 8000},
      {"Ambulancia", "🚑", 5000}
    ]

    for {nombre, emoji, tiempo} <- vehiculos do
      spawn(fn -> manejar(nombre, emoji, tiempo, tunel) end)
      :timer.sleep(3000)
    end

    :timer.sleep(10000)
    IO.puts("\n✅ Simulación finalizada.\n")
  end

  defp manejar(nombre, emoji, tiempo, tunel) do
    send(tunel, {:entrar, nombre, emoji, self()})

    receive do
      :ok ->
        :timer.sleep(tiempo)
        send(tunel, {:salir, nombre, emoji})

      :espera ->
        IO.puts("⏱️ #{nombre} (#{emoji}) espera afuera del túnel...\n")
        :timer.sleep(3000)
        manejar(nombre, emoji, tiempo, tunel)
    end
  end
end

Simulacion.run()
