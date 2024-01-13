defmodule Format do
  @moduledoc """
  This module implements a table formatter for list of maps.
  """

  def mount_table(data) do
    column_widths = column_widths(data)
    IO.inspect(column_widths)
    header = mount_header(column_widths)
    [header] ++ mount_matrix(column_widths, data)
  end

  defp to_string_all(value) when is_list(value), do: "[#{Enum.join(value, ", ")}]"

  defp to_string_all(value) when is_tuple(value), do: "{#{Enum.join(Tuple.to_list(value), ", ")}}"

  defp to_string_all(value) when is_map(value), do: raise("to_string_all not implemented to map")

  defp to_string_all(value), do: to_string(value)

  defp string_length(value), do: String.length(to_string_all(value))

  # Not clear, need refactor
  defp column_widths(data) do
    column_values =
      Enum.reduce(data, %{}, fn row, col_values ->
        Enum.reduce(row, col_values, fn {key, value}, acc ->
          Map.update(acc, key, [value], &(&1 ++ [value]))
        end)
      end)

    column_values
    |> Map.to_list()
    |> Enum.map(fn {key, values} ->
      {key,
       Enum.reduce(values, 0, fn value, acc ->
         if string_length(value) > acc, do: string_length(value), else: acc
       end)}
    end)
    |> Enum.map(fn {key, value} -> {key, max(string_length(key), value)} end)
  end

  defp mount_header(column_widths) do
    "|" <>
      Enum.reduce(column_widths, "", fn {key, width}, row ->
        row <> mount_cell(to_string(key), width)
      end) <> "\n"
  end

  defp mount_matrix(column_widths, data) do
    Enum.map(data, fn row_data -> mount_row(column_widths, row_data) end)
  end

  defp mount_row(column_widths, row_data) do
    "|" <>
      Enum.reduce(column_widths, "", fn {key, width}, row ->
        row <>
          mount_cell(
            to_string_all(Map.get(row_data, key, "")),
            width
          )
      end) <> "\n"
  end

  defp mount_cell(value, width) when is_binary(value) do
    n_spaces = width - string_length(value)
    spaces = String.duplicate(" ", n_spaces)
    " #{value}#{spaces} |"
  end
end
