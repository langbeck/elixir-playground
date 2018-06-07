defmodule Luhn do

  def generate(n) when is_binary(n), do: gen(String.to_charlist(n), String.length(n))
  def generate(n) when is_list(n), do: gen(n, length(n))

  # Check if need to start doubling the digit
  defp gen(n, size), do: gen(n, rem(size, 2) == 1, 0)

  # No more digits, just compute the remainder
  defp gen([], false, acc) do
    case rem(acc, 10) do
      0 -> 0
      n -> 10 - n
    end
  end

  # Not a valid digit
  defp gen([n | _], _, _) when n not in ?0..?9, do: :error

  # Accumulate the sum digits
  defp gen([n | tail], false, acc), do: gen(tail,  true, acc + (n - ?0))
  defp gen([n | tail],  true, acc), do: gen(tail, false, acc + double_it(n - ?0))

  defp double_it(n) when n < 5, do: (n * 2)
  defp double_it(n),            do: (n * 2) - 9
end
