defmodule Rest do
  alias Http.Response
  def init(opts \\ %{}) do
    # All of these are PIDs of running processes
    server = Map.get(opts, :server, Rest.Server)
    #authentication = Map.get(opts, :authentication, Rest.Authentication)

    server.init(opts, fn(socket, header, remaining_path) ->
      #database = Map.get(opts, :database, Rest.Database.connect())
      Response.server_header(socket)
      Response.close(socket, "asdf")
    end)
  end
end
