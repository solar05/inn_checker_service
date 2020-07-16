defmodule InnCheckerServiceWeb.Plugs.TokensService do
  import Plug.Conn
  alias InnCheckerServiceWeb.Services.IpService

  def init(_params) do
  end

  def call(conn, _params) do
    if Map.has_key?(conn.assigns, :token) and Map.has_key?(conn.assigns, :client) do
      conn
    else
      ip = IpService.extract_ip(conn)

      conn
      |> assign(:client, ip)
      |> assign(:token, Phoenix.Token.sign(conn, "client auth", ip))
    end
  end
end
