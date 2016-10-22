defmodule StaticServer.Supervisor do
  use Supervisor

  alias StaticServer.Router

  def start_link() do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Router, [port: 4000])
    ]

    Supervisor.start_link children, [strategy: :one_for_one, name: __MODULE__]
  end
end
