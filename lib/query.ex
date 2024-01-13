defmodule Query do

  # defstruct select: nil, from: nil, where: nil

  # defmacro select(fields, fun) do
  #   quote do
  #     # %__MODULE__{select: unquote(fields)}
  #   end
  # end

  # defmacro from(query, table) do
  #   quote do
  #     # %__MODULE__{unquote(query) | from: unquote(table)}
  #   end
  # end

  # defmacro where(query, conditions) do
  #   quote do
  #     # %__MODULE__{unquote(query) | where: unquote(conditions)}
  #   end
  # end

  # def select(data, fields) do
  #   res =
  #     for {k, v} <- data do
  #       {k,
  #        Enum.map(v, fn x ->
  #          x in
  #        end)}
  #     end

  #   fun.(res)
  # end

  # def from(table, fun) do
  # end

  # def where(conditions) do
  # end
end
