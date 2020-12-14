defmodule Day_14_1 do
  def answer do
    "./day14-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
  end

  def process(commands, state \\ %{mask: "", memory: %{}})

  def process([], state) do
    state
    |> Map.get(:memory)
    |> Enum.map(fn {_k, v} -> v end)
    |> Enum.map(&String.to_integer(&1, 2))
    |> Enum.sum()
  end

  def process([command | rest], state) do
    next_state =
      if String.starts_with?(command, "mask") do
        [_, new_mask] = String.split(command, " = ")

        put_in(state, [:mask], new_mask)
      else
        captures = Regex.named_captures(~r/\w+\[(?<index>\d+)\] = (?<value>\d+)/, command)

        value =
          captures["value"]
          |> decimal_string_to_binary()
          |> apply_mask(state[:mask])

        put_in(state, [:memory, captures["index"]], value)
      end

    process(rest, next_state)
  end

  defp apply_mask(nil, _), do: nil

  defp apply_mask(value, mask) do
    value_list =
      value
      |> String.pad_leading(String.length(mask), "0")
      |> String.graphemes()

    mask_list = String.graphemes(mask)

    value_list
    |> Enum.zip(mask_list)
    |> Enum.map(fn
      {value, "X"} -> value
      {_, value} -> value
    end)
    |> Enum.join("")
  end

  defp decimal_string_to_binary(string) do
    string
    |> String.to_integer(10)
    |> Integer.to_string(2)
  end
end

IO.inspect(Day_14_1.answer())

ExUnit.start()

defmodule Day_14_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """

    assert input |> Day_14_1.transform() |> Day_14_1.process() == 165
  end
end
