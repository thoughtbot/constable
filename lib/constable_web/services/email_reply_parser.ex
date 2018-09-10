defmodule Constable.EmailReplyParser do
  def remove_original_email(email) do
    email
    |> remove_quoted_email
    |> remove_trailing_newlines
  end

  defp remove_quoted_email(body) do
    Enum.reduce(reply_header_formats(), body, fn(regex, email_body) ->
      match = Regex.split(regex, email_body)
      List.first(match)
    end)
  end

  defp reply_header_formats do
    [
      ~r/\n\>?[[:space:]]*On.*<?\n?.*>?.*\n?wrote:\n?/,
    ]
  end

  defp remove_trailing_newlines(body) do
    Regex.replace(~r/\n+$/, body, "")
  end
end
