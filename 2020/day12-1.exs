defmodule Day_12_1 do
  @angle_to_direction %{0 => "E", 90 => "N", 180 => "W", 270 => "S"}

  def answer do
    "./day12-1.txt"
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
    {_, x, y} =
      input
      |> Enum.reduce({0, 0, 0}, fn command, current_pos ->
        case command["action"] do
          "F" -> forward(command["value"], current_pos)
          "L" -> rotate(+1, command["value"], current_pos)
          "R" -> rotate(-1, command["value"], current_pos)
          direction -> move(direction, command["value"], current_pos)
        end
      end)

    abs(x) + abs(y)
  end

  defp forward(value, {angle, _, _} = current_pos) do
    move(@angle_to_direction[angle], value, current_pos)
  end

  defp rotate(side, value, {angle, x, y}) do
    new_angle =
      (angle + value * side)
      |> Kernel.+(360)
      |> Integer.mod(360)

    {new_angle, x, y}
  end

  defp move("E", value, {angle, x, y}), do: {angle, x + value, y}
  defp move("N", value, {angle, x, y}), do: {angle, x, y + value}
  defp move("S", value, {angle, x, y}), do: {angle, x, y - value}
  defp move("W", value, {angle, x, y}), do: {angle, x - value, y}
end

IO.inspect(Day_12_1.answer())

ExUnit.start()

defmodule Day_12_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """

    assert input |> Day_12_1.transform() |> Day_12_1.process() == 25
  end
end
