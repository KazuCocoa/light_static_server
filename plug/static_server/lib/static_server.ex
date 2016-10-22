defmodule StaticServer do
  use Application

  alias StaticServer.Supervisor

  def init() do
    start(:ok, [])
  end

  def start(_type, _args) do
    Supervisor.start_link()
  end
end
