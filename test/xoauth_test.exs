defmodule XOAuth2Test do

  use ExUnit.Case, async: true
  import Mock
  import HTTPoison

  test "parses access token from the json response body correctly" do
    json = "{\"access_token\": \"123456789\"}"
    response = %{body: json}
    assert XOAuth2.parse_response_body(response) == "123456789"
  end

  test "returns nill when parsing for an access token on an invalid response object" do
    response = %{garbage: "this is junk"}
    XOAuth2.parse_response_body(response) == nil
  end

  test "returns nil when the response body json cannot be parsed" do
    json = "this is not json"
    response = %{body: json}
    assert XOAuth2.parse_response_body(response) == nil
  end

  test "builds a token from an access token and user ID" do
    user_id = "name@gmail.com"
    access_token = "3443lj3k5j3l5j3453453453$"
    assert is_bitstring XOAuth2.build_token(access_token, user_id)
  end

  test "calls the xoauth functions correctly when generating a token" do
    with_mock HTTPoison, [ post: fn(_url, _payload, _headers) -> "dummy response" end ] do
      with_mock URI, [ encode_query: fn(_opts) -> "payload" end] do
        opts = %XOAuth2.Opts{}
        opts = %{ opts | client_id: "client_id", client_secret: "client_secret", refresh_token: "refresh_token" }
        url_opts = XOAuth2.url_options(opts)
        headers = %{"Content-Type" => "application/x-www-form-urlencoded"}
        XOAuth2.generate_token(opts)
        assert called URI.encode_query(url_opts)
        assert called HTTPoison.post(opts.url, "payload", headers)
      end
    end
  end

end
