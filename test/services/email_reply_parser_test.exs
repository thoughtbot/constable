defmodule Constable.EmailReplyParserTest do
  use Constable.TestWithEcto

  @possible_email_body_formats [
      """
      Sweet. Yay London and Calle!

      On Fri, Apr 29, 2016 at 5:51 AM, Nick Charlton (Constable) <email@example.com> wrote:
      > Old email contents
      """,

      """
      Sweet. Yay London and Calle!

      On Fri, Apr 29, 2016 at 5:51 AM, Nick Charlton (Constable) <
      email@example.com> wrote:
      > Old email contents
      """,

      """
      Sweet. Yay London and Calle!

      On 05/02, Nick Charlton (Constable) wrote:
      > Old email contents
      """
  ]

  for phrase <- @possible_email_body_formats do
    test ".parse_body parses possible inputs correctly '#{phrase}'" do
      assert Constable.EmailReplyParser.remove_original_email(unquote(phrase)) == "Sweet. Yay London and Calle!"
    end
  end
end
