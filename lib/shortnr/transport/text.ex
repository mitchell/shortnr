defmodule Shortnr.Transport.Text do
  @moduledoc """
  This modules contains functions to decode and encode text formatted http requests and responses.
  """

  alias Shortnr.Transport.HTTP
  alias Shortnr.Transport.Text.Encodable

  import Plug.Conn

  @spec decode(HTTP.ok_error()) :: HTTP.ok_error()
  def decode({:ok, _body, conn}) do
    {:ok, body, conn} = read_body(conn)
    {:ok, body, conn}
  end

  @spec encode(HTTP.ok_error()) :: HTTP.ok_error()
  def encode(ok_error = {:error, _, _}), do: ok_error

  def encode({:ok, [], conn}) do
    {:ok, "", conn}
  end

  def encode({:ok, body, conn}) when is_list(body) do
    {:ok, for(item <- body, into: "", do: "#{item}\n"), conn}
  end

  def encode({:ok, body, conn}) do
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
