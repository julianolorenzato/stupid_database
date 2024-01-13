defmodule StupidDatabase do
  def from(data, table) do
    data[table]
  end

  def select(data, columns) when is_list(columns) do
    Enum.map(data, &row_select(&1, columns))
  end

  defp row_select(row, columns) when is_list(columns) do
    Map.take(row, columns)
  end

  def where(data, conditions) when is_list(conditions) do
    Enum.reduce(conditions, data, fn {column, filters}, data ->
      Enum.reduce(filters, data, fn filter, data ->
        filter_data(filter, column, data)
      end)
    end)
  end

  defp filter_data(filter, column, data) do
    data
    |> Enum.filter(fn row ->
      case filter do
        {:eq, value} -> row[column] == value
        {:gt, value} -> row[column] > value
        {:gte, value} -> row[column] >= value
        {:lt, value} -> row[column] < value
        {:lte, value} -> row[column] <= value
        {:ctns, value} -> String.contains?(row[column], value)
        {:sw, value} -> String.starts_with?(row[column], value)
      end
    end)
  end

  def order_by(data, column, order) do
    Enum.sort(data, fn row1, row2 ->
      case order do
        :asc -> row1[column] < row2[column]
        :desc -> row1[column] > row2[column]
      end
    end)
  end

  def group_by(data, nil, aggregate) do

  end

  def group_by(data, column, aggregate) do
    groups = Enum.group_by(data, fn row -> row[column] end)

    IO.inspect(groups)

    Enum.map(groups, fn {group_key, group_values} ->
      %{}
      |> Map.put(column, group_key)
      |> Map.put(
        aggregate,
        case aggregate do
          :count -> Enum.count(group_values)
          :sum -> Enum.sum(group_values)
          _ -> "wrong aggregate"
        end
      )
    end)
  end
end
