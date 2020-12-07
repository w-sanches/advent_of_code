defmodule Day_06_1 do
  def answer do
    "./day06-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  def process(input) do
    input
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end
end

IO.puts(Day_06_1.answer())

ExUnit.start()

defmodule Day_06_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    assert input |> Day_06_1.transform() |> Day_06_1.process() == 11
  end
end
