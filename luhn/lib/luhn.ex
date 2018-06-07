defmodule Luhn do

  def verify(n) when is_binary(n), do: verify(String.to_charlist(n), String.length(n))
  def verify(n) when is_list(n), do: verify(n, length(n))

  # Check if need to start doubling the digit
  defp verify(n, size), do: calc(n, :verify, rem(size, 2) == 0, 0)

  def generate(n) when is_binary(n), do: generate(String.to_charlist(n), String.length(n))
  def generate(n) when is_list(n), do: generate(n, length(n))

  # Check if need to start doubling the digit
  defp generate(n, size), do: calc(n, :generate, rem(size, 2) == 1, 0)

  # No more digits, just compute the remainder
  defp calc([], :generate, false, acc) do
    case rem(acc, 10) do
      0 -> 0
      n -> 10 - n
    end
  end

  defp calc([], :verify, true, acc) do
    case rem(acc, 10) do
      0 -> :ok
      _ -> {:error, :invalid}
    end
  end

  # Not a valid digit
  defp calc([n | _], type, _, _) when n not in ?0..?9, do: bad_digit_error(type)

  # Accumulate the sum digits
  defp calc([n | tail], type, false, acc), do: calc(tail, type,  true, acc + (n - ?0))
  defp calc([n | tail], type,  true, acc), do: calc(tail, type, false, acc + double_it(n - ?0))

  defp double_it(n) when n < 5, do: (n * 2)
  defp double_it(n),            do: (n * 2) - 9

  defp bad_digit_error(:verify),   do: {:error, :format}
  defp bad_digit_error(:generate), do: :error
end
