defmodule Shortnr.Router do
  @moduledoc """
  This module contains the Router for the Shortnr application. Do not import, other than
  Application entry.
  """
  alias Shortnr.Transport.HTTP
  alias Shortnr.URL

  require Logger

  use Plug.ErrorHandler
  use Plug.Router

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  # BEGIN URL routes
  post("/urls/:url", do: URL.Endpoints.select(conn, :create, url))

  get("/", do: URL.Endpoints.select(conn, :list))
  get("/urls", do: URL.Endpoints.select(conn, :list))
  get("/:id", do: URL.Endpoints.select(conn, :get, id))

  delete("/:id", do: URL.Endpoints.select(conn, :delete, id))
  # END

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
