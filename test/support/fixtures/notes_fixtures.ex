defmodule Notifyapp.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Notifyapp.Notes` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Notifyapp.Notes.create_note()

    note
  end
end
