defmodule StaticServer.Router do
  use Plug.Router

  alias StaticServer.Render

  plug :match
  plug :dispatch

  @root Path.absname("")

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

  def file_listing(directory) do
    {:ok, files} = File.ls(@root <> "/" <> directory)
    files
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
    ~S"""
    %html
      %a{:href => '/'}top
    """
    |> Calliope.render
  end

  def index(files, file_path) do
    ~S"""
    %h1 File Server
    %table
      %tr
        %th File
        %th Size
      - for file <- @files do
        %tr
          %td
            - if @file_path == "" do
              - case File.dir?(file) do
                - false ->
                  %a{title: "#{file}", href: "/files/#{Path.basename(file)}"}= Path.basename(file)
                - true ->
                  %a{title: "#{file}", href: "/#{Path.basename(file)}"}= Path.basename(file)
            - else
              - case File.dir?(@file_path <> "/" <> file) do
                - false ->
                  %a{title: "#{file}", href: "/files/#{@file_path}/#{Path.basename(file)}"}= Path.basename(file)
                - true ->
                  %a{title: "#{file}", href: "/#{@file_path}/#{Path.basename(file)}"}= Path.basename(file)
          %td
            - if @file_path == "" do
              - {:ok, %{size: size}} = File.stat(file)
                = "#{size}b"
            - else
              - {:ok, %{size: size}} = File.stat("#{@file_path}/#{Path.basename(file)}")
                = "#{size}b"
    """
    |> Calliope.render
    |> EEx.eval_string(assigns: [files: files, file_path: file_path])
  end
end
