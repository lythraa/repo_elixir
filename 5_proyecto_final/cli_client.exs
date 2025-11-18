# Simple instructions to connect to the Taxi TCP server
# Usage: in a terminal run `nc 127.0.0.1 4040` (netcat) or `telnet 127.0.0.1 4040`.
# This project provides a TCP server; it's simplest to use netcat as a CLI client.

IO.puts("Taxi CLI client helper")
IO.puts("To connect to the server run in a terminal:\n  nc 127.0.0.1 4040\nor:\n  telnet 127.0.0.1 4040")

IO.puts("Once connected, you can type commands such as:\n  connect alice pass client\n  request_trip origen=Parque destino=Centro\n  list_trips\n  accept_trip trip1\n  score\n  ranking")
