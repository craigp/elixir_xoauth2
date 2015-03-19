defmodule XOAuth2.Opts do

  defstruct url: "https://accounts.google.com/o/oauth2/token",
    user_id: "",
    client_id: "",
    client_secret: "",
    access_token: "",
    refresh_token: "",
    expiry_date: "",
    token_type: "Bearer"

  def from_config do
    Map.merge(%XOAuth2.Opts{}, Enum.into(Application.get_env(:gmail, :xoauth2), %{}))
  end

end

