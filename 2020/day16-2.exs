defmodule Day_16_2 do
  def answer do
    "./day16-2.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    [rules_string, my_ticket_string, nearby_tickets_string] =
      String.split(file_input, "\n\n", trim: true)

    rules =
      rules_string
      |> String.split("\n", trim: true)
      |> Enum.into(%{}, fn rule ->
        [name, values] = String.split(rule, ": ")

        valid_values =
          values
          |> String.split(" or ")
          |> Enum.flat_map(&string_to_values/1)

        {name, valid_values}
      end)

    my_ticket =
      my_ticket_string
      |> String.split("\n", trim: true)
      |> Enum.at(1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    nearby_tickets =
      nearby_tickets_string
      |> String.split("\n", trim: true)
      |> Enum.drop(1)
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn value -> Enum.map(value, &String.to_integer/1) end)

    {rules, my_ticket, nearby_tickets}
  end

  def process({rules, my_ticket, nearby_tickets}) do
    valid_values =
      rules
      |> Enum.map(fn {_name, ranges} -> ranges end)
      |> List.flatten()

    field_order =
      nearby_tickets
      |> Enum.filter(&is_valid_ticket?(&1, valid_values))
      |> Enum.concat([my_ticket])
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&find_possible_fields(&1, rules))
      |> Enum.with_index()
      |> Enum.sort_by(fn {fields, _index} -> Enum.count(fields) end)
      |> Enum.reduce({[], []}, fn {candidates, index}, {fields, chosen_fields} ->
        [field] = candidates -- chosen_fields

        {[{field, index} | fields], [field | chosen_fields]}
      end)
      |> elem(0)
      |> Enum.sort_by(&elem(&1, 1))
      |> Enum.map(&elem(&1, 0))

    field_order
    |> Enum.zip(my_ticket)
    |> Enum.filter(fn {field, _value} -> String.starts_with?(field, "departure") end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(1, fn value, acc -> value * acc end)
  end

  defp string_to_values(string) do
    [min, max] =
      string
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    Enum.to_list(min..max)
  end

  defp is_valid_ticket?(ticket, valid_values) do
    Enum.all?(ticket, fn value -> Enum.member?(valid_values, value) end)
  end

  defp find_possible_fields(field_values, rules) do
    rules
    |> Enum.filter(fn {_name, range} ->
      Enum.all?(field_values, fn value -> Enum.member?(range, value) end)
    end)
    |> Enum.map(&elem(&1, 0))
  end
end

IO.inspect(Day_16_2.answer())

ExUnit.start()

defmodule Day_16_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    departure row: 0-5 or 8-19
    seat: 0-13 or 16-19
    departure class: 0-1 or 4-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    99,1,5
    5,14,9
    """

    assert input |> Day_16_2.transform() |> Day_16_2.process() == 132
  end
end
