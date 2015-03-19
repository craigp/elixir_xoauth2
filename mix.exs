defmodule XOAuth2.Mixfile do
  use Mix.Project

  def project do
    [
      app: :xoauth2,
      version: "0.0.3",
      elixir: "~> 1.0",
      deps: deps,
      description: "A simple XOAuth2 module for Elixir",
      package: package
    ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [ {:httpoison, "~> 0.5"}, {:poison, "~> 1.2"}, {:mock, "~> 0.1"} ]
  end

  defp package do
    [
      files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      contributors: ["Craig Paterson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/craigp/elixir_xoauth2"}]
  end

end
