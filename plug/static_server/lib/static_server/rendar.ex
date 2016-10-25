defmodule StaticServer.Render do

  alias Calliope.render

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
              %td
                - {:ok, %{size: size}} = File.stat(file)
                  = "#{size}b"
            - else
              - case File.dir?(@file_path <> "/" <> file) do
                - false ->
                  %a{title: "#{file}", href: "/files/#{@file_path}/#{Path.basename(file)}"}= Path.basename(file)
                - true ->
                  %a{title: "#{file}", href: "/#{@file_path}/#{Path.basename(file)}"}= Path.basename(file)
              %td
                - {:ok, %{size: size}} = File.stat("#{@file_path}/#{Path.basename(file)}")
                  = "#{size}b"
    """
    |> Calliope.render
    |> EEx.eval_string(assigns: [files: files, file_path: file_path])
  end
end
