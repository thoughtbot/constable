defmodule Constable.AnnouncementInterest do
  use Ecto.Schema
  alias Constable.Announcement
  alias Constable.Interest

  schema "announcements_interests" do
    timestamps()

    belongs_to :announcement, Announcement
    belongs_to :interest, Interest
  end
end
