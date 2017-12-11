defmodule ConstableWeb.InterestView do
  use Constable.Web, :view

  import Constable.User, only: [interested_in?: 2]
end
