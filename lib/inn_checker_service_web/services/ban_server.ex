defmodule InnCheckerServiceWeb.Services.BanServer do
  use GenServer

  def start_link(ban_list \\ MapSet.new([]), opts) do
    GenServer.start_link(__MODULE__, ban_list, opts)
  end

  def init(_) do
    check_timeout()
    {:ok, MapSet.new([])}
  end

  def handle_info(:check_timeout, ban_list) do
    if Enum.empty?(ban_list) do
      check_timeout()
      {:noreply, ban_list}
    else
      timeout_list = Enum.filter(ban_list, fn {_client, ban_timeout} -> ban_timeout <= 0 end)

      if Enum.empty?(timeout_list) do
        new_ban_list = tick_ban_list(ban_list)
        check_timeout()
        {:noreply, new_ban_list}
      else
        diff = MapSet.difference(ban_list, MapSet.new(timeout_list))
        new_ban_list = tick_ban_list(diff)
        check_timeout()
        {:noreply, new_ban_list}
      end
    end
  end

  defp check_timeout do
    Process.send_after(self(), :check_timeout, 60 * 1000)
  end

  def handle_call({:ban_user, %{client: client, minutes: time}}, _from, ban_list) do
    if banned?(client, ban_list) do
      {:reply, :banned, ban_list}
    else
      {:reply, :ok, MapSet.put(ban_list, {client, time})}
    end
  end

  def handle_call({:banned?, %{client: client}}, _from, ban_list) do
    if banned?(client, ban_list) do
      {:reply, :banned, ban_list}
    else
      {:reply, :not_banned, ban_list}
    end
  end

  def handle_call({:unban, %{client: client}}, _from, ban_list) do
    user = find_user(client, ban_list)

    if Enum.empty?(user) do
      {:reply, :ok, ban_list}
    else
      new_ban_list = MapSet.difference(ban_list, MapSet.new(user))
      {:reply, :ok, new_ban_list}
    end
  end

  def handle_call({:ban_list, _}, _from, ban_list) do
    {:reply, ban_list, ban_list}
  end

  def banned?(client, ban_list) do
    result =
      ban_list
      |> Enum.filter(fn {ip, _time} -> ip == client end)
      |> Enum.empty?()

    not result
  end

  def find_user(client, ban_list) do
    Enum.filter(ban_list, fn {ip, _ban_timeout} -> ip == client end)
  end

  def tick_ban_list(ban_list) do
    ban_list
    |> Enum.map(fn {client, ban_timeout} -> {client, ban_timeout - 1} end)
    |> MapSet.new()
  end
end
