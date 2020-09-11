defmodule InnCheckerServiceWeb.SnilsCheckerTest do
  use InnCheckerServiceWeb.ConnCase
  alias InnCheckerServiceWeb.Services.SnilsChecker

  @valid_snils "34380710664"
  @invalid_snils "12345678901"

  test "Valid snils" do
    assert SnilsChecker.is_control_sum_valid(%{number: @valid_snils})
  end

  test "Invalid snils" do
    assert SnilsChecker.is_control_sum_valid(%{number: @invalid_snils}) == false
  end

  test "Invalid snils length" do
    assert SnilsChecker.is_control_sum_valid(%{number: "73"}) == false
  end
end
