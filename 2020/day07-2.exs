defmodule Day_07_2 do
  def answer do
    "./day07-2.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
  end

  def process(input) do
    rule_map =
      input
      |> Enum.map(&to_nodes/1)
      |> List.flatten()
      |> Enum.into(%{})

    count_inner_bags(rule_map, rule_map["shiny gold"]) - 1
  end

  defp count_inner_bags(_rules, []), do: 1
  defp count_inner_bags(_rules, 0), do: 1
  defp count_inner_bags(_rules, nil), do: 1

  defp count_inner_bags(rules, [h | t]) do
    count_inner_bags(rules, t) + h.amount * count_inner_bags(rules, rules[h.colour])
  end

  defp to_nodes(rule) do
    [container_colour, content_colours] = String.split(rule, " bags contain ")

    if content_colours != "no other bags." do
      contents =
        content_colours
        |> String.split(", ")
        |> Enum.map(fn bag_description ->
          %{"amount" => amount, "colour" => content_colour} =
            Regex.named_captures(~r/(?<amount>\d+) (?<colour>[\s\w]+) bag/, bag_description)

          %{amount: String.to_integer(amount), colour: content_colour}
        end)

      {container_colour, contents}
    else
      {container_colour, 0}
    end
  end
end

IO.inspect(Day_07_2.answer())

ExUnit.start()

defmodule Day_07_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    """

    assert input |> Day_07_2.transform() |> Day_07_2.process() == 126
  end
end
