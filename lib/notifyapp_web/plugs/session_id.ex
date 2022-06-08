defmodule NotifyappWeb.Plugs.SessionId do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  @impl true
  def init(default), do: default

  @impl true
  def call(conn, _config) do
    case get_session(conn, :session_id) do
      nil ->
        session_id = unique_session_id()
        put_session(conn, :session_id, session_id)

      _ ->
        conn
    end
  end

  defp unique_session_id do
    :crypto.strong_rand_bytes(16) |> Base.encode16()
  end
end
