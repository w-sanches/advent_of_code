defmodule Day_15_2 do
  def answer do
    "./day15-2.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def process(input, state \\ %{}, position \\ 1)

  def process([number], _, 30_000_000) do
    number
  end

  def process([number], state, position) do
    new_state = Map.put(state, number, position)

    next_number =
      case state[number] do
        nil -> 0
        last_position -> position - last_position
      end

    process([next_number], new_state, position + 1)
  end

  def process([number | tail], state, position) do
    new_state = Map.put(state, number, position)

    process(tail, new_state, position + 1)
  end
end

IO.inspect(Day_15_2.answer())

ExUnit.start()

defmodule Day_15_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    0,3,6
    """

    assert input |> Day_15_2.transform() |> Day_15_2.process() == 175_594
  end
end
