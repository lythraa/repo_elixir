defmodule ListasTuplasMapas do
  def ejemplo do
    IO.puts("=== LISTAS ===")
    # Crear una lista
    colores = ["rojo", "verde", "azul"]
    IO.puts("Lista de colores:")
    IO.inspect(colores)

    # Acceso al primer elemento (head) y resto (tail)
    [h | t] = colores
    IO.puts("Head: #{h}")
    IO.puts("Tail:")
    IO.inspect(t)
    # Añadir elementos
    nueva_lista = ["amarillo" | colores]
    IO.puts("Lista con nuevo color al inicio:")
    IO.inspect(nueva_lista)

    lista_concatenada = colores ++ ["negro", "blanco"]
    IO.puts("Lista concatenada:")
    IO.inspect(lista_concatenada)

    # Eliminar elemento
    lista_sin_verde = List.delete(colores, "verde")
    IO.puts("Lista sin el color 'verde':")
    IO.inspect(lista_sin_verde)

    # ======================================================
    IO.puts("\n=== TUPLAS ===")
    # Crear tupla
    persona = {"Ana", 22}
    IO.puts("Tupla de persona:")
    IO.inspect(persona)

    # Acceder a elementos
    nombre = elem(persona, 0)
    edad = elem(persona, 1)
    IO.puts("Nombre: #{nombre}, Edad: #{edad}")

    # Cambiar un valor en la tupla (las tuplas son inmutables)
    persona_actualizada = put_elem(persona, 1, 23)
    IO.puts("Tupla actualizada:")
    IO.inspect(persona_actualizada)

    # ======================================================
    IO.puts("\n=== MAPAS ===")
    # Crear mapa con strings como claves
    mapa = %{"nombre" => "Ana", "edad" => 22}
    IO.puts("Mapa con claves string:")
    IO.inspect(mapa)

    # Crear mapa con átomos como claves
    mapa_atomico = %{nombre: "Ana", edad: 22}
    IO.puts("Mapa con claves átomo:")
    IO.inspect(mapa_atomico)

    Map.get(mapa_atomico, :nombre)
    Map.get(mapa, "nombre")

    #Usando Pattern Matching
    %{nombre: nombre2, edad: edad2} = mapa_atomico
    IO.puts("Nombre usando pattern matching: #{nombre2}, Edad: #{edad2}")

    # Acceso a valores
    IO.puts("Nombre en mapa string: #{mapa["nombre"]}")
    IO.puts("Edad en mapa atómico: #{mapa_atomico.edad}")

    # Actualizar valor
    mapa_actualizado = %{mapa_atomico | edad: 23}
    IO.puts("Mapa actualizado:")
    IO.inspect(mapa_actualizado)

    # Añadir nueva clave-valor
    mapa_con_ciudad = Map.put(mapa_actualizado, :ciudad, "Madrid")
    IO.puts("Mapa con ciudad añadida:")
    IO.inspect(mapa_con_ciudad)

    # Eliminar clave
    mapa_sin_edad = Map.delete(mapa_con_ciudad, :edad)
    IO.puts("Mapa sin edad:")
    IO.inspect(mapa_sin_edad)
  end
end

# Ejecutar
ListasTuplasMapas.ejemplo()
#ESTUDIAR EL ENUM.REDUCE CON MAPAS LISTAS Y TUPLAS!!!!!!!!!!!!!!!!!!!!!!!11
