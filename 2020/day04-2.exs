defmodule Day_04_2 do
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
    "./day04-2.txt"
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
    |> Enum.map(fn passport -> Enum.all?(@passport_fields, &valid_field?(passport, &1)) end)
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

  defp valid_field?(passport, "byr"), do: is_integer_between?(passport["byr"], 1920, 2002)

  defp valid_field?(passport, "iyr"), do: is_integer_between?(passport["iyr"], 2010, 2020)

  defp valid_field?(passport, "eyr"), do: is_integer_between?(passport["eyr"], 2020, 2030)

  defp valid_field?(passport, "hgt") do
    match = Regex.named_captures(~r/^(?<height>\d+)(?<unit>cm|in)$/, passport["hgt"] || "")

    case match["unit"] do
      "cm" ->
        is_integer_between?(match["height"], 150, 193)

      "in" ->
        is_integer_between?(match["height"], 59, 76)

      nil ->
        false
    end
  end

  defp valid_field?(passport, "hcl"), do: Regex.match?(~r/^#[0-9a-f]{6}$/, passport["hcl"] || "")

  defp valid_field?(passport, "ecl") do
    Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], passport["ecl"])
  end

  defp valid_field?(passport, "pid"), do: Regex.match?(~r/^\d{9}$/, passport["pid"] || "")

  defp is_integer_between?(nil, _a, _b), do: false

  defp is_integer_between?(value, a, b) do
    with {value, ""} <- Integer.parse(value) do
      Enum.member?(a..b, value)
    else
      _ -> false
    end
  end
end

IO.puts(Day_04_2.answer())

ExUnit.start()

defmodule Day_04_2Test do
  use ExUnit.Case, async: true

  test "process/1" do
    input = """
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007

    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
    """

    assert input |> Day_04_2.transform() |> Day_04_2.process() == 4
  end
end
