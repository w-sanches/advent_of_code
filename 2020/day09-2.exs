defmodule Day_10_2 do
  def answer do
    "./day10-2.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
  end

  def process(input) do
    input
  end
end

IO.inspect(Day_10_2.answer())

ExUnit.start()

defmodule Day_10_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    """

    assert input |> Day_10_2.transform() |> Day_10_2.process(5) == 62
  end
end
