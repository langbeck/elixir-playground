defmodule LuhnTest do
  use ExUnit.Case
  doctest Luhn

  test "generate using well formatted inputs" do
    test_luhn_generate([
      {"37828224631000", 5},
      {"37144963539843", 1},
      {"37873449367100", 0},
      {"3056930902590", 4},
      {"7992739871", 3},
    ])
  end

  test "verify using well formatted valid inputs" do
    test_luhn_verify([
      {"378282246310005", :ok},
      {"371449635398431", :ok},
      {"378734493671000", :ok},
      {"30569309025904", :ok},
      {"79927398713", :ok},
    ])
  end

  test "verify using well formatted invalid inputs" do
    test_luhn_verify([
      {"378282246310006", {:error, :invalid}},
      {"371449635398430", {:error, :invalid}},
      {"378734493671009", {:error, :invalid}},
      {"30569309025903", {:error, :invalid}},
      {"79927398711", {:error, :invalid}},
    ])
  end

  test "generate using invalid digits" do
    invalid_digits()
    |> Enum.zip(Stream.repeatedly(fn-> :error end))
    |> test_luhn_generate()
  end

  test "verify using invalid digits" do
    invalid_digits()
    |> Enum.zip(Stream.repeatedly(fn-> {:error, :format} end))
    |> test_luhn_verify()
  end

  defp invalid_digits() do
    [
      ".123456",
      "123456.",
      "-123456",
      "123456-",
      "a123456",
      "1a23456",
      "12a3456",
      "123a456",
      "1234a56",
      "12345a6",
      "123456a",

      # Spaces
      " 123456",
      "1 23456",
      "12 3456",
      "123 456",
      "1234 56",
      "12345 6",
      "123456 ",

      # Multiple spaces
      "12 4 6 ",
    ]
  end

  defp test_luhn_generate(cases) do
    Enum.each(cases, fn {n, dig} -> assert Luhn.generate(n) == dig end)
  end

  defp test_luhn_verify(cases) do
    Enum.each(cases, fn {n, status} -> assert Luhn.verify(n) == status end)
  end
end
