defmodule Shortnr.Transport.Json do
  import Plug.Conn
  alias Shortnr.Transport.HTTP

  @spec decode_request(Plug.Conn.t(), module()) :: HTTP.ok_error()
  def decode_request(conn, struct_module) do
    {:ok, body, conn} = read_body(conn)
    {:ok, params} = Jason.decode(body)

    params_list =
      params
      |> Map.to_list()
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)

    {:ok, struct(struct_module, params_list), conn}
  end

  @spec encode_response(HTTP.ok_error()) :: HTTP.ok_error()
  def encode_response({:error, {status, response}, conn}) do
    {:ok, json_body} = Jason.encode(%{data: response})
    {:error, {status, json_body}, conn}
  end

  def encode_response({:ok, response, conn}) do
    {:ok, json_body} = Jason.encode(%{data: response})
    {:ok, json_body, conn}
  end
end
