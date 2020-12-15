defmodule Day_15_1 do
  def answer do
    "./day15-1.txt"
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

  def process([number], _, 2020) do
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

IO.inspect(Day_15_1.answer())

ExUnit.start()

defmodule Day_15_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    0,3,6
    """

    assert input |> Day_15_1.transform() |> Day_15_1.process() == 436
  end
end
