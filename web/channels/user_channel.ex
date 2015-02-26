defmodule ConstableApi.UserChannel do
  use ConstableApi.AuthorizedChannel
  alias ConstableApi.User
  alias ConstableApi.Repo
  alias ConstableApi.Serializers

  def handle_in("users:current", _params, socket) do
    user_id = current_user_id(socket)
    user = Repo.one(from u in User, where: u.id == ^user_id)

    reply socket, "users:current", Serializers.to_json(user)
  end
end
