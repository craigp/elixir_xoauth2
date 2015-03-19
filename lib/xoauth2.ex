defmodule XOAuth2 do

  import XOAuth2.Opts
  import URI, only: [encode_query: 1]
  import HTTPoison, only: [post: 3]
  import Poison.Parser, only: [parse: 1]

  def generate_token(opts \\ %XOAuth2.Opts{}) do
    payload = opts
      |> url_options
      |> encode_query
    case post(opts.url, payload, %{"Content-Type" => "application/x-www-form-urlencoded"}) do
      {:ok, response} ->
        response
          |> parse_response_body
          |> build_token(opts.user_id)
      _ -> nil
    end
  end

  def url_options(opts) do
    url_opts = %{
      grant_type: "refresh_token",
      client_id: opts.client_id,
      client_secret: opts.client_secret,
      refresh_token: opts.refresh_token
    }
    url_opts
  end

  def parse_response_body(%HTTPoison.Response{body: body}) do
    case parse(body) do
      {:ok, %{"access_token" => token}} -> token
      {:ok, _body} -> nil
      {:error, _error} -> nil
    end
  end

  def build_token(access_token, user_id) do
    ["user=" <> user_id, "auth=Bearer " <> access_token, "", ""]
      |> Enum.join("\x{01}")
      |> Base.encode64
  end

end
