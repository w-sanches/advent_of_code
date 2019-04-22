defmodule Day_03_1 do
  def answer do
    process(File.read!("day03-1.txt"))
  end

  def process(input) do
    input
    |> parse_lines()
    |> map_frequencies()
    |> count_adjacent()
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

  def map_frequencies(claims) when is_list(claims) do
    claims
    |> Enum.map(&map_frequency/1)
    |> Enum.reduce(%{}, fn frequencies, acc ->
      Map.merge(acc, frequencies, fn _key, frequency_map1, frequency_map2 ->
        Map.merge(frequency_map1, frequency_map2, fn _key, value1, value2 ->
          value1 + value2
        end)
      end)
    end)
  end

  defp map_frequency({left, top, width, heigth}) do
    left..(left + width - 1)
    |> Enum.to_list()
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(fn value -> {value, map_frequency({top, heigth})} end)
    |> Map.new()
  end

  defp map_frequency({start, length}) do
    start..(start + length - 1)
    |> Enum.to_list()
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(fn value -> {value, 1} end)
    |> Map.new()
  end

  def count_adjacent(frequencies) do
    Enum.reduce(frequencies, 0, fn {_key, frequency}, acc ->
      Enum.reduce(frequency, 0, fn {_key, value}, acc ->
        acc + if value >= 2, do: 1, else: 0
      end) + acc
    end)
  end
end

IO.puts(Day_03_1.answer())

ExUnit.start()

defmodule Day_03_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert Day_03_1.process(input) == 4
  end

  test "parse_line/1" do
    input = "#1 @ 1,3: 4x4"

    assert Day_03_1.parse_line(input) == {1, 3, 4, 4}
  end

  test "parse_lines/1" do
    input = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert Day_03_1.parse_lines(input) == [
             {1, 3, 4, 4},
             {3, 1, 4, 4},
             {5, 5, 2, 2}
           ]
  end

  test "map_frequencies/1" do
    input =
      """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
      """
      |> String.split("\n", trim: true)
      |> Enum.map(&Day_03_1.parse_line/1)

    assert Day_03_1.map_frequencies(input) == %{
             "1" => %{"3" => 1, "4" => 1, "5" => 1, "6" => 1},
             "2" => %{"3" => 1, "4" => 1, "5" => 1, "6" => 1},
             "3" => %{"1" => 1, "2" => 1, "3" => 2, "4" => 2, "5" => 1, "6" => 1},
             "4" => %{"1" => 1, "2" => 1, "3" => 2, "4" => 2, "5" => 1, "6" => 1},
             "5" => %{"1" => 1, "2" => 1, "3" => 1, "4" => 1, "5" => 1, "6" => 1},
             "6" => %{"1" => 1, "2" => 1, "3" => 1, "4" => 1, "5" => 1, "6" => 1}
           }
  end

  test "count_adjacent/1" do
    input =
      """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
      """
      |> String.split("\n", trim: true)
      |> Enum.map(&Day_03_1.parse_line/1)
      |> Day_03_1.map_frequencies()

    assert Day_03_1.count_adjacent(input) == 4
  end
end
