defmodule Notifyapp.Alerts do
  @moduledoc """
  The Notifications context.
  """

  alias Phoenix.PubSub
  alias __MODULE__

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications()
      [%Notification{}, ...]

  """
  def send_message_session(socket, msg, type, expire) do
    PubSub.broadcast(
      Notifyapp.PubSub,
      alerts_topic_id(socket),
      {:toast,
       %{
         id: Ecto.UUID.generate(),
         time: DateTime.utc_now(),
         type: type,
         expire: expire,
         msg: msg
       }}
    )
  end

  def send_message_session(socket, msg) do
    send_message_session(socket, msg, :info, 10000)
  end

  def send_message_session(socket, msg, type, expire) do
    PubSub.broadcast(
      Notifyapp.PubSub,
      alerts_topic_id(socket),
      {:toast,
       %{
         id: Ecto.UUID.generate(),
         time: DateTime.utc_now(),
         type: type,
         expire: expire,
         msg: msg
       }}
    )
  end

  def send_message_session(socket, msg) do
    send_message_session(socket, msg, :info, 10000)
  end


  defp alerts_topic_id(socket), do: "alerts-#{socket.assigns.session_id}"
end
