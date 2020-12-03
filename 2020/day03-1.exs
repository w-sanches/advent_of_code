defmodule Day_03_1 do
  def answer do
    "./day03-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def process(input) do
    input
    |> Enum.with_index()
    |> remove_first()
    |> Enum.reduce(0, fn {line, index}, total_trees ->
      position = Integer.mod(index * 3, length(line))

      if is_tree?(line, position) do
        total_trees + 1
      else
        total_trees
      end
    end)
  end

  defp remove_first([_h | t]), do: t
  defp remove_first([]), do: []

  defp is_tree?(line, position) do
    Enum.at(line, position) == "#"
  end
end

IO.puts(Day_03_1.answer())

ExUnit.start()

defmodule Day_03_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

    assert input |> Day_03_1.transform() |> Day_03_1.process() == 7
  end
end
