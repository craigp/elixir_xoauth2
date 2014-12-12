defmodule XOAuth2Opts do
  defstruct url: "https://accounts.google.com/o/oauth2/token", 
    user_id: "",
    client_id: "",
    client_secret: "",
    access_token: "",
    refresh_token: "",
    expiry_date: "",
    token_type: "Bearer"
  
end
