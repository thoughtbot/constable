defmodule Constable.Services.HubProfile do
  def profile_url(user) do
    "#{Application.fetch_env!(:constable, :hub_url)}/people/#{fetch_slug(user)}"
  end

  defp fetch_slug(user) do
    case Neuron.query(person_by_email_query(user.email)) do
      {:ok, %Neuron.Response{body: %{"data" => %{"person" => %{"slug" => slug}}}}} ->
        slug

      _ ->
        nil
    end
  end

  defp person_by_email_query(email) do
    """
      {
        person(email: "#{email}") {
          slug
        }
      }
    """
  end
end
