defmodule Rest.Util do
  alias Http.Response

  @doc """
    Encode a string into json with the correct format and response
    code for Ember Data and send it
  """
  def rest_error(socket, error_message) when is_bitstring(error_message), do:
    rest_error(socket, %{"error" => error_message})

  @doc """
    Encode a map into json with the correct format and response
    code for Ember Data and send it
  """
  def rest_error(socket, errors) when is_map(errors) do
    Response.header(socket, 420, "REST Error")
    Response.close(socket, :jiffy.encode(%{"errors" => errors}))
  end

end 
