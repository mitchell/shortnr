defmodule Shortnr.Router do
  use Plug.ErrorHandler
  use Plug.Router

  require Logger

  alias Shortnr.Transport.{Json, Http}
  alias Shortnr.Url

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  post "/urls" do
    conn
    |> Json.decode_request(Url.CreateRequest)
    |> Http.handle(&Url.create(&1, Url.Repo.DETS))
    |> Json.encode_response()
    |> Http.send(:created, conn)
  end

  match _ do
    {:error, {:not_found, "route not found"}, conn}
    |> Json.encode_response()
    |> Http.send(:ignore, conn)
  end

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: stack}) do
    Logger.error(inspect(reason), stack: stack)

    {:error, {:internal_server_error, "internal server error"}, conn}
    |> Json.encode_response()
    |> Http.send(:ignore, conn)
  end
end
