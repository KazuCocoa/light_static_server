defmodule StaticServer.Router do
  use Plug.Router

  alias StaticServer.Render

  plug :match
  plug :dispatch

  get "/" do
    send_resp conn, 200, Render.top
  end

  get "/:file_name" do
    send_resp conn, 200, Render.index(file_name)
  end

  get "/files/:file_name" do
    send_resp conn, 200, Render.index(file_name)
  end

  match _ do
    send400 conn
  end

  defp send400(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(400, "Bad Request")
  end
end

defmodule StaticServer.Render do
  @root Path.absname("")

  def top do
    ~s"""
    %html
      %a{:href => '/'}top
    """
    |> Calliope.render
  end

  def index(filename) do
    ~s"""
    %h1 File Server
    %table
      %tr
        %th File
        %th Size

    file_path: #{@root}/#{filename}
    """
    |> Calliope.render
  end
end
