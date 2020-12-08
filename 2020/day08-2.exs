defmodule Day_08_2 do
  def answer do
    "./day08-2.txt"
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

  def process(input) do
    reachable_from_start = reachable_from(input, 0)

    lead_to_end =
      input
      |> find_reached_by()
      |> find_lead_to(Enum.count(input))
      |> List.flatten()

    line_to_change =
      input
      |> Enum.reject(fn {_line, {op, _arg}} -> op == "acc" end)
      |> Enum.map(fn {line, instruction} -> {line, swap_instruction(instruction)} end)
      |> Enum.map(&to_destination/1)
      |> Enum.find(fn {dest, line} ->
        Enum.member?(reachable_from_start, line) && Enum.member?(lead_to_end, dest)
      end)
      |> elem(1)

    input
    |> Map.update!(line_to_change, &swap_instruction/1)
    |> run_program()
  end

  defp reachable_from(input, index) do
    input
    |> Enum.map(&to_destination/1)
    |> Enum.map(fn {dest, origin} -> {origin, dest} end)
    |> Enum.into(%{})
    |> collect_until_loop(index)
  end

  defp collect_until_loop(map, index, exec_trace \\ []) do
    next_line = map[index]

    if Enum.member?(exec_trace, next_line) do
      exec_trace
    else
      collect_until_loop(map, next_line, [index | exec_trace])
    end
  end

  defp find_reached_by(input) do
    input
    |> Enum.map(&to_destination/1)
    |> Enum.group_by(fn {dest, _origin} -> dest end, fn {_dest, origin} -> origin end)
  end

  defp swap_instruction(instruction) do
    case instruction do
      {"jmp", arg} -> {"nop", arg}
      {"nop", arg} -> {"jmp", arg}
    end
  end

  defp to_destination({line, {op, arg}}) do
    next_line =
      case op do
        "jmp" -> line + arg
        "nop" -> line + 1
        "acc" -> line + 1
      end

    {next_line, line}
  end

  defp find_lead_to(reachability_map, index) do
    reaches = Access.get(reachability_map, index, [])

    reaches ++ Enum.map(reaches, fn new_index -> find_lead_to(reachability_map, new_index) end)
  end

  defp run_program(input, acc \\ 0, line \\ 0) do
    {next_acc, next_line} =
      case input[line] do
        {"acc", arg} -> {acc + arg, line + 1}
        {"jmp", arg} -> {acc, line + arg}
        {"nop", _arg} -> {acc, line + 1}
      end

    if Map.has_key?(input, next_line) do
      run_program(input, next_acc, next_line)
    else
      next_acc
    end
  end
end

IO.inspect(Day_08_2.answer())

ExUnit.start()

defmodule Day_08_2Test do
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

    assert input |> Day_08_2.transform() |> Day_08_2.process() == 8
  end
end
