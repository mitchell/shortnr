defmodule Shortnr.Transport.Text do
  @moduledoc """
  This modules contains functions to decode and encode text formatted http requests and responses.
  """

  import Plug.Conn
  alias Shortnr.Transport.HTTP
  alias Shortnr.Transport.Text.Encodable

  @spec decode_request(Plug.Conn.t()) :: HTTP.ok_error()
  def decode_request(conn) do
    {:ok, body, conn} = read_body(conn)
    {:ok, body, conn}
  end

  @spec encode_response(HTTP.ok_error()) :: HTTP.ok_error()
  def encode_response(ok_error = {:error, _, _}), do: ok_error

  def encode_response({:ok, [], conn}) do
    {:ok, "", conn}
  end

  def encode_response({:ok, body, conn}) when is_list(body) do
    {:ok, for(item <- body, into: "", do: "#{item}\n"), conn}
  end

  def encode_response({:ok, body, conn}) do
    {:ok, Encodable.encode(body), conn}
  end
end

defprotocol Shortnr.Transport.Text.Encodable do
  @moduledoc """
  Implement this protocol for your type if you would like to text encode it.
  """

  @fallback_to_any true
  def encode(encodable)
end

defimpl Shortnr.Transport.Text.Encodable, for: Any do
  def encode(encodable), do: to_string(encodable)
end
