defmodule NotifyappWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.nice_index_path(@socket, :index)}>
        <.live_component
          module={NotifyappWeb.NiceLive.FormComponent}
          id={@nice.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.nice_index_path(@socket, :index)}
          nice: @nice
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div
      id="modal"
      class="overflow-y-auto fixed inset-0 z-10 pt-6 phx-modal"
      phx-remove={hide_modal()}
    >
      <div
        id="modal-content"
        class="flex justify-center items-end px-4 pt-4 pb-20 text-center sm:block sm:p-0"
      >
        <div class="fixed inset-0 transition-opacity" aria-hidden="true">
          <div class="absolute inset-0 bg-gray-800 opacity-75"></div>
        </div>

        <div
          id="modal-content"
          class="inline-block overflow-hidden px-4 pt-5 pb-4 text-left align-bottom bg-white rounded-lg shadow-xl transition-all transform phx-modal-content sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6"
          role="dialog"
          aria-modal="true"
          aria-labelledby="modal-headline"
          phx-click-away={JS.dispatch("click", to: "#modal-close")}
          phx-window-keydown={JS.dispatch("click", to: "#modal-close")}
          phx-key="escape"
        >
          <div class="relative">
            <%= if @return_to do %>
              <%= live_patch("✖",
                id: "modal-close",
                to: @return_to,
                phx_click: hide_modal(),
                class:
                  "inline-flex absolute right-0 text-gray-400 bg-white rounded-md phx-modal-close hover:text-gray-500 focus:outline-none"
              ) %>
            <% else %>
              <a
                id="close"
                href="#"
                class="inline-flex absolute right-0 text-gray-400 bg-white rounded-md phx-modal-close hover:text-gray-500 focus:outline-none"
                phx-click={hide_modal()}
              >
                ✖
              </a>
            <% end %>
          </div>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  # def modal(assigns) do
  #   assigns = assign_new(assigns, :return_to, fn -> nil end)

  #   ~H"""
  #   <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
  #     <div
  #       id="modal-content"
  #       class="phx-modal-content fade-in-scale border border-gray-200"
  #       phx-click-away={JS.dispatch("click", to: "#close")}
  #       phx-window-keydown={JS.dispatch("click", to: "#close")}
  #       phx-key="escape"
  #     >
  #       <%= if @return_to do %>
  #         <%= live_patch("✖",
  #           to: @return_to,
  #           id: "close",
  #           class: "phx-modal-close",
  #           phx_click: hide_modal()
  #         ) %>
  #       <% else %>
  #         <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
  #       <% end %>

  #       <%= render_slot(@inner_block) %>
  #     </div>
  #   </div>
  #   """
  # end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  @doc """
  Assign unique session_id to socket
  """
  def assign_session_id(socket, %{"session_id" => session_id}) do
    assign_new(socket, :session_id, fn -> session_id end)
  end

  @doc """
  Return a unique string per session to be used as the topic name for alerts messages
  """
  def alerts_topic_id(%{"session_id" => session_id}), do: "alerts-#{session_id}"
  def alerts_topic_id(socket), do: "alerts-#{socket.assigns.session_id}"

  @doc """
  Send a notification message to the unique pubsub topic for the current session
  """
  def send_notification(socket, type, message) do
    topic = alerts_topic_id(socket)
    PubSub.broadcast(MyApp.PubSub, topic, {type, message})
  end
end
