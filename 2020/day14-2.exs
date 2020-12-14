defmodule Day_14_2 do
  def answer do
    "./day14-2.txt"
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
          captures["index"]
          |> decimal_string_to_binary()
          |> apply_mask(state[:mask])
          |> float_bits(String.to_integer(captures["value"]))

        put_in(state, [:memory], Map.merge(state.memory, value))
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
      {_, "1"} -> "1"
      {_, "X"} -> "X"
      {value, "0"} -> value
    end)
    |> Enum.join("")
  end

  defp decimal_string_to_binary(string) do
    string
    |> String.to_integer(10)
    |> Integer.to_string(2)
  end

  defp float_bits(address, value) do
    address
    |> String.graphemes()
    |> permutations()
    |> List.flatten()
    |> Enum.map(&String.to_integer(&1, 2))
    |> Enum.into(%{}, fn address -> {address, value} end)
  end

  defp permutations(array_to_permute, permutations \\ [])

  defp permutations([], permutations), do: permutations |> Enum.reverse() |> Enum.join("")

  defp permutations([letter | rest], permutations) do
    if letter == "X" do
      [permutations(["0" | rest], permutations), permutations(["1" | rest], permutations)]
    else
      permutations(rest, [letter | permutations])
    end
  end
end

IO.inspect(Day_14_2.answer())

ExUnit.start()

defmodule Day_14_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """

    assert input |> Day_14_2.transform() |> Day_14_2.process() == 208
  end
end
