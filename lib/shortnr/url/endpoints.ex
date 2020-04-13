defmodule Shortnr.URL.Endpoints do
  @moduledoc """
  This module implements the Endpoints behaviour.
  """
  alias Shortnr.Transport.{HTTP, Text}
  alias Shortnr.URL

  def list(conn) do
    conn
    |> HTTP.wrap()
    |> HTTP.handle(fn -> URL.list(URL.Repo.ETS) end)
    |> Text.encode()
    |> HTTP.send(:ok)
  end

  def create(conn, url) do
    conn
    |> HTTP.wrap(url)
    |> HTTP.handle(&URL.create(&1, URL.Repo.ETS))
    |> Text.encode()
    |> HTTP.send(:created)
  end

  def get(conn, id) do
    conn
    |> HTTP.wrap(id)
    |> HTTP.handle(&URL.get(&1, URL.Repo.ETS))
    |> Text.encode()
    |> HTTP.send(:found)
  end

  def delete(conn, id) do
    conn
    |> HTTP.wrap(id)
    |> HTTP.handle(&URL.delete(&1, URL.Repo.ETS))
    |> Text.encode()
    |> HTTP.send(:ok)
  end
end
