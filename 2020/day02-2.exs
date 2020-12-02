defmodule Day_02_2 do
  def answer do
    "./day02-2.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      parts =
        Regex.named_captures(~r/(?<positions>\d+-\d+) (?<letter>\w+): (?<password>\w+)/, line)

      positions =
        parts["positions"]
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)
        |> Enum.map(&(&1 - 1))

      %{
        positions: positions,
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

  defp is_valid_line?(%{positions: [first, second], letter: letter, password: password}) do
    String.at(password, first) == letter != (String.at(password, second) == letter)
  end
end

IO.puts(Day_02_2.answer())

ExUnit.start()

defmodule Day_02_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

    assert input |> Day_02_2.transform() |> Day_02_2.process() == 1
  end
end
