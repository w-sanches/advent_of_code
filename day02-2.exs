defmodule Day_02_2 do
  def answer do
    input = File.read!("day02-2.txt")
    process(input)
  end

  def process(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(&only_one_char_diff/1)
    |> List.first()
    |> keep_similar_letters
  end

  def only_one_char_diff([first, _] = words) do
    String.length(keep_similar_letters(words)) == String.length(first) - 1
  end

  def keep_similar_letters(words, acc \\ [])

  def keep_similar_letters(nil, _acc), do: ""

  def keep_similar_letters([first, second], _acc)
      when is_binary(first) and is_binary(second) do
    split_first = String.split(first, "", trim: true)
    split_second = String.split(second, "", trim: true)
    Enum.join(keep_similar_letters([split_first, split_second]), "")
  end

  def keep_similar_letters([[letter | first], [letter | second]], acc) do
    [letter | keep_similar_letters([first, second], acc)]
  end

  def keep_similar_letters([[_ | first], [_ | second]], acc) do
    keep_similar_letters([first, second], acc)
  end

  def keep_similar_letters([[], _], acc), do: Enum.reverse(acc)
  def keep_similar_letters([_, []], acc), do: Enum.reverse(acc)
end

IO.puts Day_02_2.answer

ExUnit.start()

defmodule Day_02_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
    """

    output = "fgij"

    assert Day_02_2.process(input) == output
  end

  test "only_one_char_diff/1" do
    assert Day_02_2.only_one_char_diff(["aaa", "abb"]) == false
    assert Day_02_2.only_one_char_diff(["aba", "abb"]) == true
  end

  test "keep_similar_letters/1" do
    assert Day_02_2.keep_similar_letters(["a", "a"]) == "a"
    assert Day_02_2.keep_similar_letters(["ab", "ab"]) == "ab"
    assert Day_02_2.keep_similar_letters(["aba", "abb"]) == "ab"
    assert Day_02_2.keep_similar_letters(["abb", "abb"]) == "abb"
    assert Day_02_2.keep_similar_letters(["aab", "abb"]) == "ab"
  end
end
