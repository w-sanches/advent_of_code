defmodule Day_05_1 do
  def answer do
    "./day05-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(fn line ->
      rows = Enum.take(line, 7)
      columns = Enum.take(line, -3)

      {rows, columns}
    end)
  end

  def process(input) do
    input
    |> Enum.map(&get_coordinates/1)
    |> Enum.map(&get_seat_id/1)
    |> Enum.max()
  end

  defp get_coordinates({rows, columns}) do
    {get_position(rows, 0..127), get_position(columns, 0..7)}
  end

  defp get_seat_id({row, column}), do: row * 8 + column

  defp get_position(directions, range) do
    directions
    |> Enum.reduce(range, fn letter, min..max ->
      case letter do
        "F" -> min..div(min + max, 2)
        "L" -> min..div(min + max, 2)
        "B" -> (div(min + max, 2) + 1)..max
        "R" -> (div(min + max, 2) + 1)..max
      end
    end)
    |> Enum.min()
  end
end

IO.puts(Day_05_1.answer())

ExUnit.start()

defmodule Day_05_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    BFFFBBFRRR
    FFFBBBFRRR
    BBFFBBFRLL
    """

    assert input |> Day_05_1.transform() |> Day_05_1.process() == 820
  end
end
