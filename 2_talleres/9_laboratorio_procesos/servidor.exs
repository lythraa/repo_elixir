# servidor.exs
defmodule Servidor do
  def iniciar() do
    IO.puts("Servidor iniciado...")

    autores = [
      %{cedula: "1001", nombre: "Ana", apellido: "Gómez", programa: "Ing. Sistemas", titulo: "Ingeniera"},
      %{cedula: "1002", nombre: "Luis", apellido: "Pérez", programa: "Ing. Electrónica", titulo: "Ingeniero"},
      %{cedula: "1003", nombre: "Marta", apellido: "López", programa: "Ing. Industrial", titulo: "Ingeniera"},
      %{cedula: "1004", nombre: "Carlos", apellido: "Díaz", programa: "Ing. Sistemas", titulo: "Ingeniero"},
      %{cedula: "1005", nombre: "Lucía", apellido: "Rojas", programa: "Ing. Civil", titulo: "Ingeniera"}
    ]

    trabajos = [
      %{id: 1, fecha: "2023-10-10", titulo: "Sistema de Monitoreo Ambiental", descripcion: "Estación IoT", autores: ["1001", "1004"]},
      %{id: 2, fecha: "2022-08-05", titulo: "App de Gestión Académica", descripcion: "Aplicación web", autores: ["1002", "1003"]},
      %{id: 3, fecha: "2021-09-15", titulo: "Control de Inventarios", descripcion: "Sistema desktop", autores: ["1001", "1005"]}
    ]

    Process.register(self(), :servidor)
    loop(autores, trabajos)
  end

  defp loop(autores, trabajos) do
    receive do
      {:listar_trabajos, pid_cliente} ->
        send(pid_cliente, {:respuesta_trabajos, trabajos})
        loop(autores, trabajos)

      {:autores_de_trabajo_por_titulo, pid_cliente, titulo} ->
        mostrar_autores(autores, trabajos, pid_cliente, fn t -> t.titulo == titulo end)
        loop(autores, trabajos)

      {:autores_de_trabajo_por_id, pid_cliente, id} ->
        mostrar_autores(autores, trabajos, pid_cliente, fn t -> t.id == id end)
        loop(autores, trabajos)
    end
  end

  defp mostrar_autores(autores, trabajos, pid_cliente, criterio) do
    case Enum.find(trabajos, criterio) do
      nil ->
        send(pid_cliente, {:error, "Trabajo no encontrado"})

      trabajo ->
        autores_trabajo =
          Enum.filter(autores, fn a -> a.cedula in trabajo.autores end)
        send(pid_cliente, {:respuesta_autores, autores_trabajo})
    end
  end
end

Servidor.iniciar()
