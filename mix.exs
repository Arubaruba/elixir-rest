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
    Rest.init()

  # auth_func = fn(auth_params, user) ->
  #   case auth_params do
  #     # Read
  #     {"posts", data} -> true
  #     # Write
  #     {"posts", newData, data} -> user != nil
  #     _ -> false
  #     # Write / Delete 
  #     {"posts", nil, data} -> user != nil
  #     _ -> false
  #     # Write / Create
  #     {"posts", newData, nil} -> user != nil
  #     _ -> false
  #   end
  # end
  end

  defp deps do
    [{:http, github: "Arubaruba/elixir-http"},
     {:jiffy, github: "davisp/jiffy"},
      {:eredis, github: "wooga/eredis"},
      {:ex_doc, github: "elixir-lang/ex_doc", only: :dev},
      {:markdown, github: "devinus/markdown", only: :dev}
    ]
  end
end
