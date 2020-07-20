defmodule InnCheckerServiceWeb.BanServerTest do
  use InnCheckerServiceWeb.ConnCase
  alias InnCheckerServiceWeb.Services.BanServer

  @client "127.0.0.1"
  @timeout 2

  def fixture(:server) do
    {:ok, server} = GenServer.start_link(BanServer, MapSet.new([]))
    server
  end

  def fixture(:server, ban_list) do
    {:ok, server} = GenServer.start_link(BanServer, ban_list)
    server
  end

  def fixture(:ban_list) do
    result = MapSet.new([{@client, @timeout}])
    result
  end

  test "Server starting", %{conn: conn} do
    assert {:ok, _pid} = GenServer.start_link(BanServer, MapSet.new([]))
  end

  test "Ban user" do
    server = fixture(:server)
    result = GenServer.call(server, {:ban_user, %{client: @client, minutes: @timeout}})
    assert result == :ok
  end

  test "Ban already banned user" do
    ban_list = fixture(:ban_list)
    server = fixture(:server, ban_list)
    result = GenServer.call(server, {:ban_user, %{client: @client, minutes: @timeout}})
    assert result == :ok
  end

  test "Unban user" do
    ban_list = fixture(:ban_list)
    server = fixture(:server, ban_list)
    result = GenServer.call(server, {:unban, %{client: @client, minutes: @timeout}})
    assert result == :ok
  end

  test "Check banned user" do
    server = fixture(:server)
    result = GenServer.call(server, {:banned?, %{client: @client}})
    assert result == :not_banned
  end
end
