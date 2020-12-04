defmodule Day_04_1 do
  @passport_fields [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid"
  ]

  def answer do
    "./day04-1.txt"
    |> File.read!()
    |> transform()
    |> process()
  end

  def transform(file_input) do
    file_input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&Enum.join(&1, " "))
  end

  def process(input) do
    input
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&passport_string_to_map/1)
    |> Enum.map(fn passport -> Enum.all?(@passport_fields, &Map.has_key?(passport, &1)) end)
    |> Enum.count(&(&1 == true))
  end

  defp passport_string_to_map(passport) do
    passport
    |> Enum.map(&entry_to_tuple/1)
    |> Enum.into(%{})
  end

  defp entry_to_tuple(entry) do
    [key, value] = String.split(entry, ":")
    {key, value}
  end
end

IO.puts(Day_04_1.answer())

ExUnit.start()

defmodule Day_04_1Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """

    assert input |> Day_04_1.transform() |> Day_04_1.process() == 2
  end
end
