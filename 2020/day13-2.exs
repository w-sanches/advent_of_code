defmodule Day_13_2 do
  def answer do
    "./day13-2.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    [_, schedule] = String.split(file_input, "\n", trim: true)

    schedule
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.reject(fn {id, _index} -> id == "x" end)
    |> Enum.map(fn {id, index} -> {String.to_integer(id), index} end)
  end

  def process(input) do
    product = Enum.reduce(input, 1, fn {id, _index}, acc -> acc * id end)

    reduction =
      input
      |> Enum.map(fn {id, index} ->
        other_products = div(product, id)
        index * other_products * inverse_modulo(other_products, id)
      end)
      |> Enum.sum()
      |> Integer.mod(product)

    product - reduction
  end

  defp inverse_modulo(a, b) do
    {1, x, _y} = gcd(a, b)

    Integer.mod(x, b)
  end

  defp gcd(0, b), do: {b, 0, 1}

  defp gcd(a, b) do
    {g, x, y} =
      b
      |> Integer.mod(a)
      |> gcd(a)

    {g, y - div(b, a) * x, x}
  end
end

IO.inspect(Day_13_2.answer())

ExUnit.start()

defmodule Day_13_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    939
    17,x,13,19
    """

    assert input |> Day_13_2.transform() |> Day_13_2.process() == 3_417

    input = """
    939
    7,13,x,x,59,x,31,19
    """

    assert input |> Day_13_2.transform() |> Day_13_2.process() == 1_068_781
  end
end
