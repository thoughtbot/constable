defmodule ConstableWeb.InterestView do
  use ConstableWeb, :view

  import Constable.User, only: [interested_in?: 2]
end
