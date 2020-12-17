defmodule Day_17_1 do
  @max_cycles 6

  def answer do
    "./day17-1.txt"
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
      |> Enum.into(%{}, fn {value, x} -> {{x, y, 0}, value} end)
      |> Map.merge(acc)
    end)
  end

  def process(state, cycle \\ 0)

  def process(state, @max_cycles) do
    Enum.count(state, fn {_coordinates, status} -> status == "#" end)
  end

  def process(state, cycle) do
    state
    |> expand_dimensions()
    |> Enum.into(%{}, &simulate(&1, state))
    |> process(cycle + 1)
  end

  defp simulate({coordinates, status}, state) do
    active_neighbours = count_active_neighbours(coordinates, state)

    cond do
      status == "#" && active_neighbours not in [2, 3] -> {coordinates, "."}
      status == "." && active_neighbours == 3 -> {coordinates, "#"}
      true -> {coordinates, status}
    end
  end

  defp count_active_neighbours(coordinates, state) do
    for dx <- -1..1,
        dy <- -1..1,
        dz <- -1..1,
        {dx, dy, dz} != {0, 0, 0} do
      add_delta_to(coordinates, {dx, dy, dz})
    end
    |> Enum.count(fn coordinate -> state[coordinate] == "#" end)
  end

  defp add_delta_to({x, y, z}, {dx, dy, dz}) do
    {x + dx, y + dy, z + dz}
  end

  defp expand_dimensions(state) do
    {{_, _, max_z}, _} = Enum.max_by(state, fn {{_x, _y, z}, _state} -> z end)
    {{_, _, min_z}, _} = Enum.min_by(state, fn {{_x, _y, z}, _state} -> z end)
    {{_, max_y, _}, _} = Enum.max_by(state, fn {{_x, y, _z}, _state} -> y end)
    {{_, min_y, _}, _} = Enum.min_by(state, fn {{_x, y, _z}, _state} -> y end)
    {{max_x, _, _}, _} = Enum.max_by(state, fn {{x, _y, _z}, _state} -> x end)
    {{min_x, _, _}, _} = Enum.min_by(state, fn {{x, _y, _z}, _state} -> x end)

    x_expanded =
      for x <- [min_x - 1, max_x + 1],
          y <- min_y..max_y,
          z <- min_z..max_z do
        {{x, y, z}, "."}
      end
      |> Enum.into(%{})
      |> Map.merge(state)

    xy_expanded =
      for x <- (min_x - 1)..(max_x + 1),
          y <- [min_y - 1, max_y + 1],
          z <- min_z..max_z do
        {{x, y, z}, "."}
      end
      |> Enum.into(%{})
      |> Map.merge(x_expanded)

    for x <- (min_x - 1)..(max_x + 1),
        y <- (min_y - 1)..(max_y + 1),
        z <- [min_z - 1, max_z + 1] do
      {{x, y, z}, "."}
    end
    |> Enum.into(%{})
    |> Map.merge(xy_expanded)
  end
end

IO.inspect(Day_17_1.answer())

ExUnit.start()

defmodule Day_17_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    .#.
    ..#
    ###
    """

    assert input |> Day_17_1.transform() |> Day_17_1.process() == 112
  end
end
