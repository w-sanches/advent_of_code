defmodule Day_11_1 do
  def answer do
    "./day11-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.into(%{}, fn {value, x} -> {{x, y}, value} end)
      |> Map.merge(acc)
    end)
  end

  def process(seat_map) do
    new_seat_map =
      seat_map
      |> Enum.map(&simulate_person(&1, seat_map))
      |> Enum.into(%{})

    if new_seat_map == seat_map do
      count_occupied_seats(seat_map)
    else
      process(new_seat_map)
    end
  end

  defp count_occupied_seats(seat_map) do
    Enum.count(seat_map, fn {_seat, status} -> status == "#" end)
  end

  defp simulate_person({seat, status}, seat_map) do
    case status do
      "." -> {seat, status}
      "#" -> maybe_leave(seat, seat_map)
      "L" -> maybe_occupy(seat, seat_map)
    end
  end

  defp maybe_leave(seat, seat_map) do
    should_leave? =
      seat
      |> seats_around(seat_map)
      |> Enum.count(&(&1 in ["#"]))
      |> Kernel.>=(4)

    if should_leave? do
      {seat, "L"}
    else
      {seat, "#"}
    end
  end

  defp maybe_occupy(seat, seat_map) do
    can_occupy? =
      seat
      |> seats_around(seat_map)
      |> Enum.all?(&(&1 in ["L", ".", nil]))

    if can_occupy? do
      {seat, "#"}
    else
      {seat, "L"}
    end
  end

  defp seats_around(seat, seat_map) do
    [
      {-1, -1},
      {-1, +0},
      {-1, +1},
      {+0, -1},
      {+0, +1},
      {+1, -1},
      {+1, +0},
      {+1, +1}
    ]
    |> Enum.map(fn {x, y} -> seat_in_direction(seat, x, y, seat_map) end)
  end

  defp seat_in_direction({x, y}, vertical_movement, horizontal_movement, seat_map) do
    new_place = {x + horizontal_movement, y + vertical_movement}
    Map.get(seat_map, new_place)
  end
end

IO.inspect(Day_11_1.answer())

ExUnit.start()

defmodule Day_11_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """

    assert input |> Day_11_1.transform() |> Day_11_1.process() == 37
  end
end
