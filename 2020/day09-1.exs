defmodule Day_09_1 do
  def answer do
    "./day09-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def process(input, preamble \\ 25) do
    checknum = Enum.take(input, preamble)
    number_list = Enum.drop(input, preamble)

    find_first_invalid(checknum, number_list)
  end

  defp find_first_invalid(checknum, [candidate | number_list]) do
    if valid?(checknum, candidate) do
      next_checknum =
        checknum
        |> Enum.drop(1)
        |> Enum.concat([candidate])

      find_first_invalid(next_checknum, number_list)
    else
      candidate
    end
  end

  defp find_first_invalid(_, _), do: nil

  defp valid?(checknum, number) do
    combinations = for x <- checknum, y <- checknum, x != y, do: [x, y]

    combinations
    |> Enum.map(fn [x, y] -> x + y end)
    |> Enum.uniq()
    |> Enum.member?(number)
  end
end

IO.inspect(Day_09_1.answer())

ExUnit.start()

defmodule Day_09_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """

    assert input |> Day_09_1.transform() |> Day_09_1.process(5) == 127
  end
end
