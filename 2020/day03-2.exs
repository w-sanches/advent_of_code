defmodule Day_03_2 do
  def answer do
    "./day03-2.txt"
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
    trees_per_slope = [
      solve_starting(input, 1, 1),
      solve_starting(input, 3, 1),
      solve_starting(input, 5, 1),
      solve_starting(input, 7, 1),
      solve_starting(input, 1, 2)
    ]

    Enum.reduce(trees_per_slope, 1, fn trees, total -> trees * total end)
  end

  defp solve_starting(input, horizontal_movement, vertical_movement) do
    input
    |> Enum.with_index()
    |> jump_first_n_rows(vertical_movement)
    |> jump_every_other_row(vertical_movement)
    |> Enum.reduce(0, fn {line, index}, total_trees ->
      position =
        index
        |> div(vertical_movement)
        |> Kernel.*(horizontal_movement)
        |> Integer.mod(length(line))

      if is_tree?(line, position) do
        total_trees + 1
      else
        total_trees
      end
    end)
  end

  defp jump_first_n_rows(list, n) do
    Enum.reject(list, fn {_line, index} -> index < n end)
  end

  defp jump_every_other_row(list, n) do
    Enum.filter(list, fn {_line, index} -> Integer.mod(index, n) == 0 end)
  end

  defp is_tree?(line, position) do
    Enum.at(line, position) == "#"
  end
end

IO.puts(Day_03_2.answer())

ExUnit.start()

defmodule Day_03_2Test do
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

    assert input |> Day_03_2.transform() |> Day_03_2.process() == 336
  end
end
