# Game channel for the bulls game
defmodule BullsWeb.BullsChannel do
  use BullsWeb, :channel

  # Functions join and handle_in taken from Professor Tuck's notes repo


  @impl true
  def join("game:" <> _id, payload, socket) do
    if authorized?(payload) do
      game = BullsWeb.Game.new
      socket = assign(socket, :game, game)
      view = BullsWeb.Game.view(game)
      {:ok, view, socket}
    end
  end

  @impl true
  def handle_in("guess", %{"guess" => guess}, socket) do
    game0 = socket.assigns[:game]
    # If the game is still going on, do the following steps
    if (!BullsWeb.Game.status(game0)) do
      game1 = BullsWeb.Game.checkGuess(game0, guess)
      game2 = BullsWeb.Game.updateState(game1, guess)
      view = BullsWeb.Game.view(game2)
      socket1 = assign(socket, :game, game2)
      {:reply, {:ok, view}, socket1}
    end
  end

  
  @impl true
  def handle_in("display", %{"display" => display}, socket) do
    game0 = socket.assigns[:game]
    game1 = BullsWeb.Game.checkGuess(game0, display)
    view = BullsWeb.Game.view(game1)
    {:reply, {:ok, view}, socket}
  end


  @impl true
  def handle_in("reset", _, socket) do
    game = BullsWeb.Game.new()
    socket1 = assign(socket, :game, game)
    view = BullsWeb.Game.view(game)
    {:reply, {:ok, view}, socket1}
  end

  # add authorization
  defp authorized?(_payload) do
    true
  end
end