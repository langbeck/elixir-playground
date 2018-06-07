defmodule LuhnTest do
  use ExUnit.Case
  doctest Luhn

  test "well formatted cases" do
    test_luhn_generate [
      {"37828224631000", 5},
      {"37144963539843", 1},
      {"37873449367100", 0},
      {"3056930902590", 4},
      {"7992739871", 3},
    ]
  end

  test "invalid digits" do
    test_luhn_generate [
      {".123456", :error},
      {"123456.", :error},
      {"-123456", :error},
      {"123456-", :error},
      {"a123456", :error},
      {"1a23456", :error},
      {"12a3456", :error},
      {"123a456", :error},
      {"1234a56", :error},
      {"12345a6", :error},
      {"123456a", :error},
    ]
  end

  test "with spaces" do
    test_luhn_generate [
      {" 123456", :error},
      {"1 23456", :error},
      {"12 3456", :error},
      {"123 456", :error},
      {"1234 56", :error},
      {"12345 6", :error},
      {"123456 ", :error},

      # Multiple spaces
      {"12 4 6 ", :error},
    ]
  end

  defp test_luhn_generate(cases) do
    cases
    |> Stream.map(fn {n, dig} -> assert Luhn.generate(n) == dig end)
    |> Stream.run()
  end
end
