defmodule Shortnr.URL.Endpoints do
  @moduledoc """
  This module implements the Endpoints behaviour.
  """
  alias Shortnr.Transport.{HTTP, Text}
  alias Shortnr.Transport.HTTP.Endpoints
  alias Shortnr.URL

  @behaviour Endpoints

  @impl Endpoints
  def select(conn, name, arg \\ nil)

  def select(conn, :list, _arg) do
    conn
    |> HTTP.wrap()
    |> HTTP.handle(fn -> URL.list(URL.Repo.ETS) end)
    |> Text.encode()
    |> HTTP.send(:ok)
  end

  def select(conn, :create, url) do
    conn
    |> HTTP.wrap(url)
    |> HTTP.handle(&URL.create(&1, URL.Repo.ETS))
    |> Text.encode()
    |> HTTP.send(:created)
  end

  def select(conn, :get, id) do
    conn
    |> HTTP.wrap(id)
    |> HTTP.handle(&URL.get(&1, URL.Repo.ETS))
    |> Text.encode()
    |> HTTP.send(:found)
  end

  def select(conn, :delete, id) do
    conn
    |> HTTP.wrap(id)
    |> HTTP.handle(&URL.delete(&1, URL.Repo.ETS))
    |> Text.encode()
    |> HTTP.send(:ok)
  end
end