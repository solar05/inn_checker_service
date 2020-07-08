defmodule InnCheckerServiceWeb.Services.IpService do
  def extract_ip(conn) do
    conn.remote_ip
    |> Tuple.to_list()
    |> Enum.join(".")
  end
end
