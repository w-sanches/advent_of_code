defmodule Day_12_2 do
  def answer do
    "./day12-2.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      ~r/(?<action>[NSEWLRF])(?<value>\d+)/
      |> Regex.named_captures(line)
      |> Map.update!("value", fn value -> String.to_integer(value) end)
    end)
  end

  def process(input) do
    {x, y, _, _} =
      Enum.reduce(input, {0, 0, 10, 1}, fn command, current_pos ->
        case command["action"] do
          "F" -> forward(command["value"], current_pos)
          "L" -> rotate("L", command["value"], current_pos)
          "R" -> rotate("R", command["value"], current_pos)
          direction -> move(direction, command["value"], current_pos)
        end
      end)

    abs(x) + abs(y)
  end

  defp forward(value, {x, y, way_x, way_y}) do
    {x + value * way_x, y + value * way_y, way_x, way_y}
  end

  defp rotate("L", 90, {x, y, way_x, way_y}), do: {x, y, -way_y, way_x}

  defp rotate("L", degrees, {x, y, way_x, way_y}),
    do: rotate("L", degrees - 90, {x, y, -way_y, way_x})

  defp rotate("R", 90, {x, y, way_x, way_y}), do: {x, y, way_y, -way_x}

  defp rotate("R", degrees, {x, y, way_x, way_y}),
    do: rotate("R", degrees - 90, {x, y, way_y, -way_x})

  defp move("E", value, {x, y, way_x, way_y}), do: {x, y, way_x + value, way_y}
  defp move("N", value, {x, y, way_x, way_y}), do: {x, y, way_x, way_y + value}
  defp move("S", value, {x, y, way_x, way_y}), do: {x, y, way_x, way_y - value}
  defp move("W", value, {x, y, way_x, way_y}), do: {x, y, way_x - value, way_y}
end

IO.inspect(Day_12_2.answer())

ExUnit.start()

defmodule Day_12_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """

    assert input |> Day_12_2.transform() |> Day_12_2.process() == 286
  end
end
