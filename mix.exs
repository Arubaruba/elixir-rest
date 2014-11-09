defmodule Rest.Mixfile do
  use Mix.Project
  alias Http.Server
  alias Http.Response
  alias Http.Request

  def project do
    [app: :rest,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps]
  end

  def application do
    [applications: [], mod: {__MODULE__, []}]
  end

  # Sample REST Server
  def start(_type, _args) do
    auth_func = fn(auth_params, user) ->
      case auth_params do
        # Read
        {"posts", data} -> true
        # Write
        {"posts", newData, data} -> user != nil
        _ -> false
      end
    end

    Server.start(fn(socket) ->
      {:ok, redis} = :eredis.start_link()
      header = Request.header(socket)
      case tl String.split(header.path, "/") do
        ["data" | _] -> Rest.serve(socket, redis, header, auth_func)
        _ ->
          Response.header(socket, 404, "Invalid Url")
          Response.close(socket, "Invalid Url: #{header.path}")
      end
    end, 3030)
  end

  defp deps do
    [{:http, github: "Arubaruba/elixir-http"},
     {:jiffy, github: "davisp/jiffy"},
      {:eredis, github: "wooga/eredis"},
      {:ex_doc, github: "elixir-lang/ex_doc"},
      {:markdown, github: "devinus/markdown", only: :dev}
    ]
  end
end
