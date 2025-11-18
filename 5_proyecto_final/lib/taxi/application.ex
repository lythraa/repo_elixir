defmodule Taxi.Application do
  @moduledoc """
  Módulo principal de la aplicación de taxis.
  Inicia y supervisa todos los procesos necesarios:
  - Registry para viajes y sesiones de usuario
  - Supervisor para tareas TCP
  - Supervisor dinámico para viajes
  - Gestores de usuarios, ubicaciones y servidor TCP
  """

  use Application

  require Logger

  def start(_type, _args) do
    Logger.info("Starting Taxi application...")

    children = [
      {Registry, keys: :unique, name: Taxi.TripRegistry},
      # registry for active user sessions (allow multiple sessions per user)
      {Registry, keys: :duplicate, name: Taxi.SessionRegistry},
      {Task.Supervisor, name: Taxi.TaskSupervisor},
      Taxi.TripSupervisor,
      Taxi.UserManager,
      Taxi.Location,
      Taxi.Server
    ]

    opts = [strategy: :one_for_one, name: Taxi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
