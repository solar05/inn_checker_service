defmodule InnCheckerServiceWeb.IpServiceTest do
  use InnCheckerServiceWeb.ConnCase
  alias InnCheckerServiceWeb.Services.IpService

  @ip "127.0.0.1"

  test "Ip extraction", %{conn: conn} do
    ip = IpService.extract_ip(conn)
    assert ip =~ @ip
  end
end
