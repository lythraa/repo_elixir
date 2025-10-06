Code.require_file("util.ex")

defmodule Cliente do
  defstruct nombre: "", edad: 0, altura: 0.0

  @doc """
  Crea una estructura Cliente con los datos proporcionados.
  Retorna la estructura Cliente.
  """
  def crear(nombre, edad, altura) do
    %Cliente{nombre: nombre, edad: edad, altura: altura}
  end

  @doc """
  Permite ingresar los datos de un cliente desde la consola.
  Retorna una estructura Cliente con los datos ingresados.
  """
  def ingresar(mensaje) do
    mensaje
    |> Util.mostrar_mensaje()

    nombre =
      "Ingrese el nombre: "
      |> Util.ingresar(:texto)

    edad =
      "Ingrese la edad: "
      |> Util.ingresar(:entero)

    altura =
      "Ingrese la altura: "
      |> Util.ingresar(:real)

    crear(nombre, edad, altura)
  end

  @doc """
  Permite ingresar una lista de clientes desde la consola.
  Retorna una lista de estructuras Cliente.
  """
  def ingresar(mensaje, :clientes) do
    mensaje
    |> ingresar([], :clientes)
  end

  @doc """
  Función recursiva para ingresar múltiples clientes.
  Retorna una lista de estructuras Cliente.
  """
  def ingresar(mensaje, lista, :clientes) do
    cliente =
      mensaje
      |> ingresar()

    nueva_lista = lista ++ [cliente]

    mas_clientes =
      "¿Desea ingresar otro cliente? (si/no): "
      |> Util.ingresar(:boolean)

    case mas_clientes do
      true ->
        mensaje
        |> ingresar(nueva_lista, :clientes)

      false ->
        nueva_lista
    end
  end

  @doc """
  Genera un mensaje concatenando las líneas generadas por la función pasada como argumento.
  Retorna el mensaje generado.
  """
  def generar_mensaje_clientes(lista_clientes, parser) do
    lista_clientes
    |> Enum.map(parser)
    |> Enum.join("")
  end

  @doc """
  Genera un archivo CSV con la información de una lista de clientes.
  Retorna :ok si el archivo se crea correctamente.
  """
  def escribir_csv(clientes, nombre) do
    clientes
    |> generar_mensaje_clientes(&convertir_cliente_linea_csv/1)
    # adiciona los encabezados
    |> (&("nombre, edad, altura\n" <> &1)).()
    # escribe en el archivo
    |> (&File.write(nombre, &1)).()
  end

  # Convierte una estructura Cliente en una línea de un archivo CSV.
  # Retorna la línea en formato CSV.
  defp convertir_cliente_linea_csv(cliente) do
    "#{cliente.nombre}, #{cliente.edad}, #{cliente.altura}\n"
  end
end
