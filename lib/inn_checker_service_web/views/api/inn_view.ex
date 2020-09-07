defmodule InnCheckerServiceWeb.Api.InnView do
  use InnCheckerServiceWeb, :view

  def render("inn.json", %{inn: inn}) do
    %{
      id: inn.id,
      number: inn.number,
      check_date: to_string(Timex.shift(inn.updated_at, hours: 3)),
      state: inn.state
    }
  end

  def render("inn_error.json", %{errors: errors}) do
    [number: {msg, _}] = errors
    %{errors: msg}
  end
end
