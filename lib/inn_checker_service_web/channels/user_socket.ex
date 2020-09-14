defmodule InnCheckerServiceWeb.UserSocket do
  use Phoenix.Socket

  channel "document:*", InnCheckerServiceWeb.DocumentChannel

  @impl true
  def connect(params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
