defmodule Constable.EmailReplyParser do
  def remove_original_email(email) do
    email
    |> String.split("\n")
    |> remove_quoted_email
    |> Enum.join("\n")
    |> remove_trailing_newlines
  end

  defp remove_quoted_email(lines) do
    if Enum.any?(lines, &line_starts_with_email?/1) do
      lines
      |> Enum.take_while(&is_from_new_email?/1)
      |> Enum.drop(-1)
    else
      lines
      |> Enum.take_while(&is_from_new_email?/1)
    end
  end

  defp line_starts_with_email?(line) do
    Regex.match?(~r/^\w+@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}/, line)
  end

  defp is_from_new_email?(line) do
    !String.contains?(line, "@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}")
  end

  defp remove_trailing_newlines(body) do
    Regex.replace(~r/\n+$/, body, "")
  end
end
