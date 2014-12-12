defmodule XOAuth2 do

  import XOAuth2Opts
  import URI, only: [encode_query: 1]
  import HTTPoison, only: [post: 3]
  import JSX, only: [decode: 1]
  
  def generate_token(opts \\ %XOAuth2Opts{}) do
    payload = encode_query(url_options(opts))
    headers = %{"Content-Type" => "application/x-www-form-urlencoded"}
    case post(opts.url, payload, headers) do
      {:ok, response} ->
        response 
          |> parse_response_body
          |> build_token(opts.user_id)
      _ -> nil
    end
  end

  def url_options(opts) do
    %{
      grant_type: "refresh_token",
      client_id: opts.client_id,
      client_secret: opts.client_secret,
      refresh_token: opts.refresh_token
    }
  end

  def parse_response_body(response) do
    case Dict.has_key?(response, :body) do
      true ->
        case decode(response.body) do
          {:ok, json} ->
            case Dict.get(json, "access_token") do
              nil ->
                nil
              access_token ->
                access_token
            end
          _ -> 
            nil
        end
      false ->
        nil
    end
  end

  def build_token(access_token, user_id) do
    auth_data = [
      "user=" <> user_id,
      "auth=Bearer " <> access_token,
      "",
      ""
    ]
    Base.encode64(Enum.join(auth_data, "\x{01}"))
  end

end
