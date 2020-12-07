defmodule Day_07_1 do
  def answer do
    "./day07-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
  end

  def process(input) do
    rules =
      input
      |> Enum.map(&to_nodes/1)
      |> Enum.reject(&is_nil/1)
      |> List.flatten()
      |> Enum.into(%{})

    rules
    |> Map.keys()
    |> Enum.map(&may_contain?(rules, &1, "shiny gold"))
    |> Enum.count(&(&1 == true))
  end

  defp may_contain?(rules, current_colour, search_colour) do
    cond do
      is_nil(rules[current_colour]) ->
        false

      Enum.member?(rules[current_colour], search_colour) ->
        true

      true ->
        rules[current_colour]
        |> Enum.map(&may_contain?(rules, &1, search_colour))
        |> Enum.any?(&(&1 == true))
    end
  end

  defp to_nodes(rule) do
    [container_colour, content_colours] = String.split(rule, " bags contain ")

    unless content_colours == "no other bags." do
      contents =
        content_colours
        |> String.split(", ")
        |> Enum.map(fn bag_description ->
          %{"colour" => content_colour} =
            Regex.named_captures(~r/\d+ (?<colour>[\s\w]+) bag/, bag_description)

          content_colour
        end)

      {container_colour, contents}
    end
  end
end

IO.inspect(Day_07_1.answer())

ExUnit.start()

defmodule Day_07_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """

    assert input |> Day_07_1.transform() |> Day_07_1.process() == 4
  end
end
