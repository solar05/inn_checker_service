defmodule InnCheckerServiceWeb.InnCheckerTest do
  use InnCheckerServiceWeb.ConnCase
  alias InnCheckerServiceWeb.Services.InnChecker

  @ten_digit_valid_inn "7743013901"
  @ten_digit_invalid_inn "7743013902"
  @twelwe_digit_valid_inn "732897853530"
  @twelwe_digit_invalid_inn "732897853531"

  test "ten_digit_valid_inn" do
    assert InnChecker.is_control_sum_valid(%{number: @ten_digit_valid_inn})
  end

  test "ten_digit_invalid_inn" do
    assert InnChecker.is_control_sum_valid(%{number: @ten_digit_invalid_inn}) == false
  end

  test "twelwe_digit_valid_inn" do
    assert InnChecker.is_control_sum_valid(%{number: @twelwe_digit_valid_inn})
  end

  test "twelwe_digit_invalid_inn" do
    assert InnChecker.is_control_sum_valid(%{number: @twelwe_digit_invalid_inn}) == false
  end

  test "invalid_inn_length" do
    assert InnChecker.is_control_sum_valid(%{number: "73"}) == false
  end
end
