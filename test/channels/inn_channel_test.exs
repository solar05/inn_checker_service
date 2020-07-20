defmodule InnCheckerServiceWeb.InnChannelTest do
  use InnCheckerServiceWeb.ChannelCase, async: true
  alias InnCheckerServiceWeb.InnChannel
  alias InnCheckerServiceWeb.UserSocket

  test "Connect to user socket" do
    assert {:ok, socket} = connect(UserSocket, %{})
  end
end
