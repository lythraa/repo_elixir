defmodule Maximo do
  def mayor([x]), do: x

  def mayor([head | tail]) do
    max_del_resto = mayor(tail)

    if head > max_del_resto do
      head
    else
      max_del_resto
    end
  end
end

