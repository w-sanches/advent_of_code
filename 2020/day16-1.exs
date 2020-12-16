defmodule Day_16_1 do
  def answer do
    "./day16-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    [rules, _my_ticket, nearby_tickets] = String.split(file_input, "\n\n", trim: true)

    valid_values =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(fn rule ->
        rule
        |> String.split(": ")
        |> Enum.at(1)
        |> String.split(" or ")
        |> Enum.map(&string_to_range/1)
      end)
      |> List.flatten()

    nearby_tickets_values =
      nearby_tickets
      |> String.split("\n", trim: true)
      |> Enum.drop(1)
      |> Enum.map(&String.split(&1, ","))
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    {valid_values, nearby_tickets_values}
  end

  def process({valid_values, nearby_tickets_values}) do
    nearby_tickets_values
    |> Enum.reject(fn value -> Enum.any?(valid_values, &Enum.member?(&1, value)) end)
    |> Enum.sum()
  end

  defp string_to_range(string) do
    [min, max] =
      string
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    min..max
  end
end

IO.inspect(Day_16_1.answer())

ExUnit.start()

defmodule Day_16_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """

    assert input |> Day_16_1.transform() |> Day_16_1.process() == 71
  end
end
