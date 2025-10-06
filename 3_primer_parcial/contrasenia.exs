Code.require_file("util.ex")

defmodule Contrasenia do
  import Util

  @doc """
  Inicia el programa:
    - Pide al usuario una contraseña.
    - Valida la contraseña.
    - Muestra si es segura o los errores encontrados.
  """
  def main do
    contrasenia = ingresar("Ingrese una contraseña: ", :texto)

    case validar(contrasenia) do
      {:ok, msg} ->
        mostrar_mensaje("#{msg}")

      {:error, msg} ->
        mostrar_mensaje("Errores: \n#{msg}")
    end
  end


  @moduledoc """
  Programa para revisar si una contraseña es segura.
  Reglas:
    - Mínimo 8 caracteres.
    - Debe tener al menos una mayúscula.
    - Debe tener al menos un número.
    - No debe tener espacios.
  """

  @doc """
  Revisa la contraseña y devuelve:
    - {:ok, "Contraseña segura"} si cumple todas las reglas.
    - {:error, "lista de errores"} si no cumple alguna.
  """
  def validar(contrasenia) do
    errores = []

    # Regla: longitud mínima
    errores =
      if String.length(contrasenia) < 8 do
        ["Debe tener al menos 8 caracteres" | errores]
      else
        errores
      end

    # Regla: al menos una mayúscula
    errores =
      if String.match?(contrasenia, ~r/[A-Z]/) do
        errores
      else
        ["Debe contener al menos una letra mayúscula" | errores]
      end

    # Regla: al menos un número
    errores =
      if String.match?(contrasenia, ~r/[0-9]/) do
        errores
      else
        ["Debe contener al menos un número" | errores]
      end

    # Regla: no debe tener espacios
    errores =
      if String.contains?(contrasenia, " ") do
        ["No debe contener espacios" | errores]
      else
        errores
      end

    # Resultado final
    if errores == [] do
      {:ok, "Contraseña segura"}
    else
      {:error, Enum.join(Enum.reverse(errores), "\n")}
    end
  end
end


Contrasenia.main()
