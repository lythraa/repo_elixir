defmodule Util do
  @moduledoc """
Utilidades para mostrar mensajes en consola.
- autor: leidy suarez
-fecha: 19/08/25
.licencia: GNU General Public License v3.0
"""
  @doc """
muestra un mensaje en la consola utilizando una clase Java.
- mensaje: El mensaje a mostrar. como no te vas a acordar ? si es super como unica si te entienfo es mentidrsrdfg
no es mentiraaaaaaaaaa :c si es
"""
  def mostrar_mensaje(mensaje) do
    System.cmd("java", ["UtilJava", mensaje])
  end
  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end
end
