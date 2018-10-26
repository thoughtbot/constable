defmodule ConstableWeb.SharedView do
  require Ecto.Query

  alias Constable.Services.MentionFinder
  import Exgravatar

  use Phoenix.HTML

  def title(%{page_title: title}) do
    "- #{title}"
  end

  def title(_my_assigns) do
    ""
  end

  def gravatar(user) do
    gravatar_url(user.email, secure: true)
  end

  def relative_timestamp(datetime) do
    content_tag(
      :time,
      simple_date(datetime),
      [
        {:data,
         [
           format: "%B %e, %Y %l:%M%P",
           local: "time-ago"
         ]},
        datetime: DateTime.to_iso8601(datetime)
      ]
    )
  end

  def user_autocomplete_json(users) do
    users
    |> Enum.map(&format_user_json/1)
    |> Poison.encode!
  end

  def simple_date(datetime) do
    Enum.join([datetime.year, datetime.month, datetime.day], "/")
  end

  def time_ago_in_words(time) do
    ts = NaiveDateTime.to_erl(time) |> :calendar.datetime_to_gregorian_seconds
    diff = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time) - ts
    rel_from_now(:calendar.seconds_to_daystime(diff))
  end

  defp rel_from_now({0, {0, 0, sec}}) when sec < 30,
    do: "just now"
  defp rel_from_now({0, {0, min, _}}) when min < 2,
    do: "1 minute ago"
  defp rel_from_now({0, {0, min, _}}),
    do: "#{min} minutes ago"
  defp rel_from_now({0, {1, _, _}}),
    do: "1 hour ago"
  defp rel_from_now({0, {hour, _, _}}) when hour < 24,
    do: "#{hour} hours ago"
  defp rel_from_now({1, {_, _, _}}),
    do: "1 day ago"
  defp rel_from_now({day, {_, _, _}}) when day < 0,
    do: "just now"
  defp rel_from_now({day, {_, _, _}}),
    do: "#{day} days ago"

  def markdown_with_users(markdown) do
    markdown
    |> MentionFinder.find_users
    |> bold_usernames(markdown)
    |> Constable.Markdown.to_html
  end

  def on_first_page?(page) do
    page.page_number == 1
  end

  def on_last_page?(page) do
    page.total_pages == page.page_number
  end

  defp bold_usernames(users, text) do
    Enum.reduce(users, text, fn(user, text) ->
      String.replace(text, "@#{user.username}", "**@#{user.username}**")
    end)
  end

  defp format_user_json(user) do
    %{name: user.name, username: user.username, gravatar_url: gravatar(user)}
  end
end
