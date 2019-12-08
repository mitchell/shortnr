defmodule Shortnr.Transport.Text do
  import Plug.Conn
  alias Shortnr.Transport.Http
  alias Shortnr.URL

  @spec decode_request(Plug.Conn.t()) :: Http.ok_error()
  def decode_request(conn) do
    {:ok, body, conn} = read_body(conn)
    {:ok, body, conn}
  end

  @spec encode_response(Http.ok_error()) :: Http.ok_error()
  def encode_response(ok_error = {:error, _, _}), do: ok_error

  def encode_response({:ok, [], conn}) do
    {:ok, "", conn}
  end

  def encode_response({:ok, body, conn}) when is_list(body) do
    {:ok, for(item <- body, into: "", do: "#{item}\n"), conn}
  end

  def encode_response({:ok, %URL{url: url}, conn}) do
    {:ok, url, conn}
  end

  def encode_response({:ok, body, conn}) do
    {:ok, "#{body}", conn}
  end
end
