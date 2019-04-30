defmodule Day_03_2 do
  def answer do
    # process(File.read!("day03-2.txt"))
    ""
  end

  def process(input) do
    input
    |> parse_lines()
    |> keep_disjointed()
  end

  def parse_lines(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    regex = ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/

    [_ | data] = Regex.run(regex, line)

    [id, left, top, width, heigth] = Enum.map(data, &String.to_integer/1)

    List.to_tuple([id, left..(left + width - 1), top..(top + heigth - 1)])
  end

  def keep_disjointed(claims) do
    claims
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

    assert Day_03_2.parse_line(input) == {1, 1..4, 3..6}
  end

  test "keep_disjointed/1"

  test "parse_lines/1" do
    input = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert Day_03_2.parse_lines(input) == [
             {1, 1..4, 3..6},
             {2, 3..6, 1..4},
             {3, 5..6, 5..6}
           ]
  end
end
