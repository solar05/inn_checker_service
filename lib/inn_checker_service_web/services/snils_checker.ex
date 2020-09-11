defmodule InnCheckerServiceWeb.Services.SnilsChecker do
  alias InnCheckerService.Papers.Document

  @coefficients [9, 8, 7, 6, 5, 4, 3, 2, 1]

  def check_snils(snils) do
    is_control_sum_valid(snils)
  end

  def is_control_sum_valid(%{number: number}) do
    prepared_snils = Document.prepare_document(number)

    case Enum.count(prepared_snils) do
      11 ->
        last_digits =
          number
          |> String.slice(9..10)
          |> String.to_integer()

        is_snils_valid(prepared_snils, last_digits)

      _ ->
        false
    end
  end

  @spec check_sum_calc(integer) :: integer
  def check_sum_calc(number) do
    cond do
      number < 100 ->
        number

      number == 100 ->
        0

      number > 100 ->
        remainder = rem(number, 101)
        if remainder == 100, do: 0, else: remainder
    end
  end

  def control_sum_calc(snils_numbers, coefficients_map) do
    Enum.zip(snils_numbers, coefficients_map)
    |> Enum.reduce(0, fn {a, b}, acc -> a * b + acc end)
  end

  def is_snils_valid(snils_numbers, last_digits) do
    control_sum = control_sum_calc(snils_numbers, @coefficients)
    last_digits == check_sum_calc(control_sum)
  end
end
