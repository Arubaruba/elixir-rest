defmodule RestTest do
  use ExUnit.Case
  alias Http.Request
  alias Http.Response

  setup do
    Application.stop(:rest)
    Application.start(:rest)
  end

  setup do
    {:ok, socket} = Http.Client.connect('localhost', 3030)
    {:ok, socket: socket}
  end

  test "the truth", %{socket: socket} do
    IO.inspect socket
    Response.header(socket)
    {:ok, data} = Request.data(socket)
    IO.inspect(data)
    :ok
  end
end
