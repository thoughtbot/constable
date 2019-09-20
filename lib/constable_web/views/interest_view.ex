defmodule ConstableWeb.InterestView do
  use ConstableWeb, :view

  import Constable.User, only: [interested_in?: 2]

  def interest_count_for(user) do
    length(user.interests)
  end
end
