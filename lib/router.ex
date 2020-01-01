defmodule Shortnr.Router do
  @moduledoc """
  This module contains the Router for the Shortnr application. Do not import, other than
  Application entry.
  """
  use Plug.ErrorHandler
  use Plug.Router

  require Logger

  alias Shortnr.Transport.{HTTP, Text}
  alias Shortnr.URL

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> HTTP.wrap()
    |> HTTP.handle(fn -> URL.list(URL.Repo.ETS) end)
    |> Text.encode_response()
    |> HTTP.send(:ok)
  end

  post "/urls/:url" do
    conn
    |> HTTP.wrap(url)
    |> HTTP.handle(&URL.create(&1, URL.Repo.ETS))
    |> Text.encode_response()
    |> HTTP.send(:created)
  end

  get "/urls" do
    conn
    |> HTTP.wrap()
    |> HTTP.handle(fn -> URL.list(URL.Repo.ETS) end)
    |> Text.encode_response()
    |> HTTP.send(:ok)
  end

  get "/:id" do
    conn
    |> HTTP.wrap(id)
    |> HTTP.handle(&URL.get(&1, URL.Repo.ETS))
    |> Text.encode_response()
    |> HTTP.send(:found)
  end

  delete "/:id" do
    conn
    |> HTTP.wrap(id)
    |> HTTP.handle(&URL.delete(&1, URL.Repo.ETS))
    |> Text.encode_response()
    |> HTTP.send(:ok)
  end

  match _ do
    conn
    |> HTTP.wrap({:not_found, "route not found"})
    |> HTTP.send()
  end

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: stack}) do
    Logger.error(inspect(reason), stack: ~s|"#{inspect(stack)}"|)

    conn
    |> HTTP.wrap({:internal_server_error, "internal server error"})
    |> HTTP.send()
  end
end
