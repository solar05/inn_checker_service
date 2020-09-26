defmodule InnCheckerServiceWeb.Api.DocumentView do
  use InnCheckerServiceWeb, :view

  def render("document.json", %{document: document}) do
    %{
      number: document.number,
      type: document.type,
      check_date: to_string(Timex.shift(document.updated_at, hours: 3)),
      state: document.state
    }
  end

  def render("document_error.json", %{errors: errors}) do
    case errors do
      [number: {msg, _}] ->
        %{errors: msg}

      [type: {msg, _}] ->
        %{errors: msg}
    end
  end

  def render("user_banned.json", _) do
    %{errors: "You have exceeded number of allowed checks, please try again later"}
  end
end
