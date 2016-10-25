defmodule StaticServer.Router do
  use Plug.Router

  alias StaticServer.Router
  alias StaticServer.Render

  plug :match
  plug :dispatch

  defstruct [root: Path.absname("")]

  get "/" do
    send_resp conn, 200, Render.index(file_listing("/"), "")
  end

  match _ do
    case conn.path_info do
      ["files"|tail] ->
        file_path = Path.join tail
        send_file conn, 200, file_path
      _ ->
        file_path = Path.join conn.path_info
        send_resp conn, 200, Render.index(file_listing(file_path), file_path)
    end
  end

  defp file_listing(directory) do
    {:ok, files} = File.ls(struct(Router).root <> "/" <> directory)
    files
  end

  defp send400(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(400, "Bad Request")
  end
end
