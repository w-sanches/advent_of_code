defmodule Day_10_2 do
  def answer do
    "./day10-2.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def process(input) do
    diff_list =
      input
      |> Enum.sort()
      |> Enum.map_reduce(0, fn number, acc -> {number - acc, number} end)
      |> elem(0)

    count(diff_list) + 1
  end

  defp count([a, b | rest]) when a + b <= 3 do
    1 + memoised([a + b | rest]) + memoised([b | rest])
  end

  defp count([_ | rest]), do: memoised(rest)

  defp count([]), do: 0

  defp memoised(sequence) do
    if count = Process.get(sequence) do
      count
    else
      count = count(sequence)
      Process.put(sequence, count)
      count
    end
  end
end

IO.inspect(Day_10_2.answer())

ExUnit.start()

defmodule Day_10_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """

    assert input |> Day_10_2.transform() |> Day_10_2.process() == 8

    input = """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """

    assert input |> Day_10_2.transform() |> Day_10_2.process() == 19208
  end
end
