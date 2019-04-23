defmodule Day_01_1 do
  def answer do
    "./day01-1.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> process()
  end

  def process(input) do
    number = Enum.find(input, fn n -> Enum.member?(input, 2020 - n) end)

    number * (2020 - number)
  end
end

IO.puts(Day_01_1.answer())

ExUnit.start()

defmodule Day_01_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = [
      1721,
      979,
      366,
      299,
      675,
      1456
    ]

    assert Day_01_1.process(input) == 514_579
  end
end
