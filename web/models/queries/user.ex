defmodule Constable.Queries.User do
  alias Constable.User
  import Ecto.Query

  def with_email(email) do
    from u in User, where: u.email == ^email
  end
end
