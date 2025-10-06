Code.require_file("cliente.ex")
Code.require_file("util.ex")

defmodule Estructura do
  @doc """
  Función principal que crea una lista de clientes y escribe sus datos en un archivo CSV.
  Retorna :ok si la operación fue exitosa.
  """
  def main do
    crear_lista_clientes()
    |> Cliente.escribir_csv("clientes.csv")
  end

  # Crea una lista de clientes de ejemplo.
  # Retorna una lista de estructuras Cliente.
  defp crear_lista_clientes() do
    [
      Cliente.crear("Ana", 28, 1.65),
      Cliente.crear("Luis", 34, 1.75),
      Cliente.crear("María", 22, 1.60),
      Cliente.crear("Carlos", 40, 1.80),
      Cliente.crear("Diana", 30, 1.70),
      Cliente.crear("Jorge", 27, 1.72)
    ]
  end

  @doc """
  Lee un archivo CSV y convierte cada línea en una estructura Cliente.
  Retorna una lista de estructuras Cliente.
  """
  def leer_csv(nombre) do
    nombre
    |> File.stream!()
    |> Stream.drop(1)
    |> Enum.map(&convertir_cadena_cliente/1)
  end

  defp convertir_cadena_cliente(cadena) do
    [nombre, edad, altura] =
      cadena
      |> String.split(", ")
      |> Enum.map(&String.trim/1)

    eda
  end
  @doc """
  Genera un mensaje personalizado para un cliente.
  Retorna una cadena de texto con el mensaje.
  """
  def generar_mensaje(cliente) do
    altura = cliente.altura |> Float.round(2)

    "Hola #{cliente.nombre}, tienes #{cliente.edad} años y" <>
      " mide #{altura} metros. \n"
  end

  @doc """
  Genera mensajes personalizados para una lista de clientes.
  Retorna una cadena de texto con los mensajes concatenados.
  """
  def generar_mensaje_clientes(lista_clientes) do
    lista_clientes
    |> Enum.map(&generar_mensaje/1)
    |> Enum.join("\n")
  end
end

Estructura.main()
