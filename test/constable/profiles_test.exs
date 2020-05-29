defmodule Constable.ProfilesTest do
  use Constable.DataCase, async: true

  alias Constable.{User, Profiles}

  describe "update_profile_info/1" do
    test "fetches and updates a user's profile info" do
      user = insert(:user, profile_url: nil, profile_image_url: nil)

      Profiles.update_profile_info(user)

      updated_user = User |> Repo.get!(user.id)
      assert updated_user.profile_url == "http://example.com/"
      assert String.ends_with?(updated_user.profile_image_url, "/images/ralph.png")
    end
  end

  describe "update_profile_image_urls/0" do
    test "updates all image urls of users" do
      users = insert_pair(:user, profile_image_url: nil)

      :ok = Profiles.update_profile_image_urls(users)

      [user1, user2] = User |> Repo.all()
      assert String.ends_with?(user1.profile_image_url, "/images/ralph.png")
      assert String.ends_with?(user2.profile_image_url, "/images/ralph.png")
    end
  end
end
