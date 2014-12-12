defmodule XOAuth2Request do
  use HTTPoison.Base

  def process_headers(headers) do
    Dict.put headers, :"Content-Type", "application/x-www-form-urlencoded"
  end
  
end
