defmodule Day_10_1 do
  def answer do
    "./day10-1.txt"
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
    max_joltage = Enum.max(input)

    counts =
      [0]
      |> Enum.concat(input)
      |> Enum.concat([max_joltage + 3])
      |> Enum.sort()
      |> Enum.chunk_every(2, 1)
      |> Enum.map(fn
        [low, high] -> high - low
        [_single] -> 0
      end)
      |> Enum.group_by(& &1)

    ones = Enum.count(counts[1])
    threes = Enum.count(counts[3])

    ones * threes
  end
end

IO.inspect(Day_10_1.answer())

ExUnit.start()

defmodule Day_10_1Test do
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

    assert input |> Day_10_1.transform() |> Day_10_1.process() == 35

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

    assert input |> Day_10_1.transform() |> Day_10_1.process() == 220
  end
end
