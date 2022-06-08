defmodule NotifyappWeb.AlertsLive.Index do
  use NotifyappWeb, :live_view


  alias Phoenix.LiveView.JS
  alias Phoenix.PubSub

  @impl true
  def mount(_params, session, socket) do
    IO.inspect("Moooounting")

    # PubSub.subscribe(Awesometemplate.PubSub, "alerts")
    subscribe_to_alarms_topic(session)





    socket =
      socket
      |> assign_session_id(session)
      |> assign(:flash_messages, nil)
      |> assign(:toast, nil)
      |> assign(:error, nil)

    {:ok, socket, layout: {NotifyappWeb.LayoutView, "empty-live.html"}}
  end




  def handle_event("remove", params, socket) do
    IO.inspect(params)

    messages = Enum.reject(socket.assigns.flash_messages, fn x -> x.id == params["value"] end)
    {:noreply, socket |> assign(:flash_messages, messages)}
  end

  def handle_event("check", params, socket) do
    IO.inspect(socket.assigns)
    {:noreply, socket}
  end


  def handle_event("msg", params, socket) do
    Notifyapp.Alerts.send_message_session(socket, "Sweet")
    {:noreply, socket}
  end

  @impl true
  def handle_info({:toast, %{id: id, msg: msg, expire: expire, time: time, type: type}}, socket) do

    if expire do
      view_pid = self()

      spawn(fn ->
        :timer.sleep(expire)
        send(view_pid, %{schedule_clear_message: id})
      end)
    end

    messages =
      if socket.assigns.flash_messages do
        [%{id: id, msg: msg, time: time, type: type} | socket.assigns.flash_messages]
        |> Enum.reverse()
      else
        [%{id: id, msg: msg, time: time, type: type}]
      end

    {:noreply, assign(socket, flash_messages: messages)}
  end

  # Enum.map(users, fn
  #   %User{id: 2} = user -> %User{user | attempts: 99}
  #   user -> user
  # end)

  # @impl true
  # def handle_info({:error, message}, socket) do
  #   send(self(), :schedule_clear_message)

  #   {:noreply, assign(socket, error: message)}
  # end

  # @impl true
  # def handle_info({:schedule_clear_message, :toast}, socket) do
  #   :timer.sleep(10000)
  #   {:noreply, assign(socket, :toast, nil)}
  # end

  @impl true
  def handle_info(%{schedule_clear_message: id}, socket) do
    IO.inspect("dddd")
    IO.inspect(id)

    messages = Enum.reject(socket.assigns.flash_messages, fn x -> x.id == id end)
    {:noreply, socket |> assign(:flash_messages, messages)}
  end

  @impl true
  def handle_info(params, socket) do
    IO.inspect(params)
    :timer.sleep(10000)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:schedule_clear_message, :error}, socket) do
    :timer.sleep(5000)
    {:noreply, assign(socket, :error, nil)}
  end

  defp subscribe_to_alarms_topic(session) do
    topic = alerts_topic_id(session)
    PubSub.subscribe(Notifyapp.PubSub, topic)
  end
end
