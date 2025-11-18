Proyecto Taxi - Simulación de flota (Elixir)

Resumen
-------
Aplicación en Elixir que simula una flota de taxis en una ciudad virtual. Los usuarios (clientes y conductores) se conectan por TCP (CLI) y pueden crear/aceptar viajes en tiempo real. Cada viaje es un GenServer gestionado por un DynamicSupervisor.

Cómo usar
--------
1. Arrancar la aplicación (desde la carpeta `proyecto_taxi`):

   mix deps.get
   mix compile
   iex -S mix

   (el servidor TCP arranca automáticamente en el puerto 4040)

2. Conectarse desde otra terminal con netcat:

   nc 127.0.0.1 4040

   Ejemplo de flujo:
   - connect ana password client
   - request_trip origen=Parque destino=Centro

   En otra terminal:
   - connect luis password driver
   - list_trips
   - accept_trip trip1

Archivos importantes
-------------------
- `lib/taxi/server.ex` - servidor TCP y parsing de comandos
- `lib/taxi/trip.ex` - GenServer por viaje
- `lib/taxi/trip_supervisor.ex` - DynamicSupervisor para viajes
- `lib/taxi/user_manager.ex` - persistencia en `data/users.dat`
- `data/users.dat`, `data/results.log`, `data/locations.dat`

Persistencia
-----------
- `data/users.dat` contiene líneas: username;role;password;score
- `data/results.log` guarda historial de viajes
- `data/locations.dat` lista de ubicaciones válidas

Notas
----
- Este proyecto es una implementación educativa y simplificada.
- Mejoras posibles: hashing de contraseñas, interfaz CLI más rica, testing automatizado, opciones de configuración (puerto), tiempos configurables.
