defmodule Day_13_1 do
  def answer do
    "./day13-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    [earliest, schedule] = String.split(file_input, "\n", trim: true)

    bus_ids =
      schedule
      |> String.split(",")
      |> Enum.reject(&(&1 == "x"))
      |> Enum.map(&String.to_integer/1)

    {String.to_integer(earliest), bus_ids}
  end

  def process({earliest_departure, bus_table}) do
    {bus_id, departure} =
      bus_table
      |> Enum.map(fn bus -> {bus, ceil(earliest_departure / bus) * bus} end)
      |> Enum.sort_by(fn {_id, departure} -> departure end)
      |> List.first()

    (departure - earliest_departure) * bus_id
  end
end

IO.inspect(Day_13_1.answer())

ExUnit.start()

defmodule Day_13_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    939
    7,13,x,x,59,x,31,19
    """

    assert input |> Day_13_1.transform() |> Day_13_1.process() == 295
  end
end
