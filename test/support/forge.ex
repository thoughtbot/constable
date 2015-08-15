defmodule Forge do
  use Blacksmith
  alias Constable.Announcement
  alias Constable.Comment
  alias Constable.Subscription
  alias Constable.User
  alias Constable.AnnouncementInterest
  alias Constable.Interest
  alias Constable.UserInterest

  @save_one_function &Blacksmith.Config.save/2
  @save_all_function &Blacksmith.Config.save_all/2

  register :announcement,
    __struct__: Announcement,
    title: Sequence.next(:email, &"Post Title#{&1}"),
    body: "Post Body",
    inserted_at: Ecto.DateTime.utc,
    updated_at: Ecto.DateTime.utc

  register :announcement_interest,
    __struct__: AnnouncementInterest

  register :user_interest,
    __struct__: UserInterest

  register :interest,
    __struct__: Interest,
    name: Sequence.next(:interest_name, &"interest-#{&1}")

  register :comment,
    __struct__: Comment,
    body: "Post Body",
    inserted_at: Ecto.DateTime.utc

  register :user,
    __struct__: User,
    name: "Gumbo",
    email: Sequence.next(:email, &"test#{&1}@thoughtbot.com")

  register :subscription,
    __struct__: Subscription

  register :socket,
    __struct__: Phoenix.Socket,
    transport_pid: self,
    router: Constable.Router,
    topic: "foo:bar",
    pubsub_server: Constable.PubSub,
    assigns: []

  register :join_message,
    __struct__: Phoenix.Socket.Message,
    topic: "topic",
    event: "phx_join",
    ref: "12345",
    payload: %{}

  register :date_time,
    __struct__: Ecto.DateTime,
    year: 2010,
    month: 4,
    day: 17,
    hour: 0,
    min: 0,
    sec: 0

  register :email_reply_message,
    text: "My email reply",
    from_email: Sequence.next(:email, &"test#{&1}@thoughtbot.com"),
    email: "constable-fakekey@thoughtbot.com"

  register :email_reply_webhook,
    event: 'inbound',
    msg: Forge.email_reply_message
end
