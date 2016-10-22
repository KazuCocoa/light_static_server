defmodule StaticServer.Mixfile do
  use Mix.Project

  def project do
    [app: :static_server,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      applications: [:logger, :cowboy, :plug],
      mod: {StaticServer, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:calliope, "~> 0.4"}
    ]
  end
end
