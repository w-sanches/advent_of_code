defmodule Day_03_2 do
  def answer do
    # process(File.read!("day03-2.txt"))
    ""
  end

  def process(input) do
    input
    |> parse_lines()
  end

  def parse_lines(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    regex = ~r/#\d+ @ (\d+),(\d+): (\d+)x(\d+)/

    [_, left, top, width, heigth] = Regex.run(regex, line)

    [left, top, width, heigth]
    |> Enum.map(fn item -> String.to_integer(item) end)
    |> List.to_tuple()
  end
end

IO.puts(Day_03_2.answer())

ExUnit.start()

defmodule Day_03_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert Day_03_2.process(input) == "3"
  end

  test "parse_line/1" do
    input = "#1 @ 1,3: 4x4"

    assert Day_03_2.parse_line(input) == {1, 3, 4, 4}
  end

  test "parse_lines/1" do
    input = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert Day_03_2.parse_lines(input) == [
             {1, 3, 4, 4},
             {3, 1, 4, 4},
             {5, 5, 2, 2}
           ]
  end
end
