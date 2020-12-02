defmodule Day_02_1 do
  def answer do
    "./day02-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      parts = Regex.named_captures(~r/(?<range>\d+-\d+) (?<letter>\w): (?<password>\w+)/, line)

      [low, high] =
        parts["range"]
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)

      %{
        range: low..high,
        letter: parts["letter"],
        password: parts["password"]
      }
    end)
  end

  def process(input) do
    input
    |> Enum.map(&is_valid_line?/1)
    |> Enum.count(&(&1 == true))
  end

  defp is_valid_line?(%{range: range, letter: letter, password: password}) do
    letter_count =
      password
      |> String.split("", trim: true)
      |> Enum.count(&(&1 == letter))

    Enum.member?(range, letter_count)
  end
end

IO.puts(Day_02_1.answer())

ExUnit.start()

defmodule Day_02_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

    assert input |> Day_02_1.transform() |> Day_02_1.process() == 2
  end
end
