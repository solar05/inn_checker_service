defmodule InnCheckerServiceWeb.Services.BanServer do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    check_timeout()
    {:ok, []}
  end

  def handle_info(:check_timeout, state) do
    # IO.inspect(Redix.command(:redix, ["PING"]))
    check_timeout()
    {:noreply, state}
  end

  defp check_timeout do
    # 60 * 60 * 1000)
    Process.send_after(self(), :check_timeout, 1000)
  end

  def handle_call({:ban_user, info}, _from, state) do
    IO.inspect(info)
    IO.inspect("RECIEVED")
    {:reply, :ok, state}
  end
end
