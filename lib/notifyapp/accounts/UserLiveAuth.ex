defmodule Notifyapp.Accounts.UserLiveAuth do
  import Phoenix.LiveView




  def on_mount(:assignSessionId, _params,  %{"session_id" => session_id}, socket) do
    socket = assign_new(socket, :session_id, fn -> session_id end)
    {:cont, socket}
  end



end
