defmodule Table do
  @moduledoc """
  This module implements a table formatter for list of maps.
  """

  # defp column_names(data) when is_list(data) do
  #   Enum.reduce(data, %{}, &Map.merge/2) |> Map.keys()
  # end

  defp to_string_length(value), do: String.length(inspect(value))

  # Take a list of maps as input and returns a keyword list
  # with the biggest string length of each column.

  # ## Examples

  #     iex> column_widths([
  #       %{name: "John Doe", age: 23},
  #       %{name: "Mary Smith", department: :marketing, is_active: true},
  #       %{name: "Sarah Wolf", salary: 320000, department: :tech}
  #     ])
  #     [name: 12, age: 2, department: 9, is_active: 4, salary: 6]

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
      {key, to_string_length(Enum.max_by(values, &to_string_length/1))}
    end)
  end

  def mount_table(data) do
    column_widths = column_widths(data)
    header = mount_header(column_widths)
    [header] ++ mount_matrix(column_widths, data)
  end

  defp mount_matrix(column_widths, data) do
    Enum.map(data, fn row_data -> mount_row(column_widths, row_data) end)
  end

  defp mount_header(column_widths) do
    "|" <>
      Enum.reduce(column_widths, "", fn {key, width}, row ->
        row <> mount_cell(to_string(key), width)
      end) <> "\n"
  end

  defp mount_row(column_widths, row_data) do
    "|" <>
      Enum.reduce(column_widths, "", fn {key, width}, row ->
        row <>
          mount_cell(
            to_string(Map.get(row_data, key, "")),
            width
          )
      end) <> "\n"
  end

  defp mount_cell(value, width) when is_binary(value) do
    n_spaces = width - String.length(value)
    spaces = String.duplicate(" ", n_spaces)
    "#{value}#{spaces}|"
  end
end
