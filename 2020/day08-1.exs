defmodule Day_08_1 do
  def answer do
    "./day08-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {instruction, line} ->
      [opcode, arg] = String.split(instruction, " ")

      {line, {opcode, String.to_integer(arg)}}
    end)
    |> Enum.into(%{})
  end

  def process(input, acc \\ 0, line \\ 0, exec_trace \\ []) do
    {next_acc, next_line} =
      case input[line] do
        {"acc", arg} -> {acc + arg, line + 1}
        {"jmp", arg} -> {acc, line + arg}
        {"nop", _arg} -> {acc, line + 1}
      end

    if Enum.member?(exec_trace, next_line) do
      acc
    else
      process(input, acc, next_line, [next_line | exec_trace])
    end
  end
end

IO.inspect(Day_08_1.answer())

ExUnit.start()

defmodule Day_08_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """

    assert input |> Day_08_1.transform() |> Day_08_1.process() == 5
  end
end
