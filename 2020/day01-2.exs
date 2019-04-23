defmodule Day_01_2 do
  def answer do
    "./day01-2.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> process()
  end

  def process(input) do
    input
    |> Enum.map(fn candidate ->
      missing = 2020 - candidate
      second = Enum.find(input, &Enum.member?(input -- [candidate], missing - &1))

      if second do
        candidate * second * (2020 - candidate - second)
      else
        0
      end
    end)
    |> Enum.find(&(&1 != 0))
  end
end

IO.puts(Day_01_2.answer())

ExUnit.start()

defmodule Day_01_2Test do
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

    assert Day_01_2.process(input) == 241_861_950
  end
end
