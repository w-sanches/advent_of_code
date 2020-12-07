defmodule Day_06_2 do
  def answer do
    "./day06-2.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  def process(input) do
    people = Enum.map(input, &Enum.count/1)

    answer_frequencies =
      input
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.frequencies/1)

    people
    |> Enum.zip(answer_frequencies)
    |> Enum.map(&answered_by_everyone/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  defp answered_by_everyone({people, frequencies}) do
    Enum.reject(frequencies, fn {_answer, frequency} ->
      frequency < people
    end)
  end
end

IO.puts(Day_06_2.answer())

ExUnit.start()

defmodule Day_06_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    assert input |> Day_06_2.transform() |> Day_06_2.process() == 6
  end
end
