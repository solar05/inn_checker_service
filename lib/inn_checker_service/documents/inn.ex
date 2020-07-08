defmodule InnCheckerService.Documents.Inn do
  use Ecto.Schema
  import Ecto.Changeset

  @ten_digits_map [2, 4, 10, 3, 5, 9, 4, 6, 8]
  @twelwe_digits_first_map [7, 2, 4, 10, 3, 5, 9, 4, 6, 8]
  @twelwe_digits_second_map [3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8]

  schema "inns" do
    field :client, :string
    field :number, :string
    field :state, :string

    timestamps()
  end

  @doc false
  def changeset(inn, attrs) do
    inn
    |> cast(attrs, [:number, :client, :state])
    |> validate_required([:number, :client, :state])
  end

  def prepare_inn(number) do
    String.split(number, "", trim: true)
    |> Enum.map(fn num -> String.to_integer(num) end)
  end

  def is_control_sum_valid(%{number: number}) do
    prepared_inn = prepare_inn(number)

    case Enum.count(prepared_inn) do
      10 ->
        is_ten_digit_inn_valid(prepared_inn)

      12 ->
        is_twelwe_digit_inn_valid(prepared_inn)

      _ ->
        false
    end
  end

  @spec sum_divide(integer) :: integer
  def sum_divide(number) do
    rem(number, 11)
    |> rem(10)
  end

  def control_sum_calc(inn_numbers, coefficients_map) do
    Enum.zip(inn_numbers, coefficients_map)
    |> Enum.reduce(0, fn {a, b}, acc -> a * b + acc end)
  end

  def is_ten_digit_inn_valid(inn_numbers) do
    last_number = List.last(inn_numbers)
    control_sum = control_sum_calc(inn_numbers, @ten_digits_map)
    last_number == sum_divide(control_sum)
  end

  def is_twelwe_digit_inn_valid(inn_numbers) do
    last_number = List.last(inn_numbers)
    {:ok, penult_number} = Enum.fetch(inn_numbers, 10)

    first_sum = control_sum_calc(inn_numbers, @twelwe_digits_first_map)
    second_sum = control_sum_calc(inn_numbers, @twelwe_digits_second_map)

    penult_number == sum_divide(first_sum) and last_number == sum_divide(second_sum)
  end
end
