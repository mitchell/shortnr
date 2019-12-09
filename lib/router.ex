defmodule Shortnr.Router do
  use Plug.ErrorHandler
  use Plug.Router

  require Logger

  alias Shortnr.Transport.{Text, Http}
  alias Shortnr.URL

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  post "/urls/:url" do
    {:ok, url, conn}
    |> Http.handle(&URL.create(&1, URL.Repo.DETS))
    |> Text.encode_response()
    |> Http.send(:created, conn)
  end

  get "/urls" do
    {:ok, :ignore, conn}
    |> Http.handle(fn -> URL.list(URL.Repo.DETS) end)
    |> Text.encode_response()
    |> Http.send(:ok, conn)
  end

  get "/:id" do
    {:ok, id, conn}
    |> Http.handle(&URL.get(&1, URL.Repo.DETS))
    |> Text.encode_response()
    |> Http.send(:found, conn)
  end

  delete "/:id" do
    {:ok, id, conn}
    |> Http.handle(&URL.delete(&1, URL.Repo.DETS))
    |> Text.encode_response()
    |> Http.send(:ok, conn)
  end

  match _ do
    {:error, {:not_found, "route not found"}, conn}
    |> Text.encode_response()
    |> Http.send(:ignore, conn)
  end

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: stack}) do
    Logger.error(inspect(reason), stack: inspect(stack))

    {:error, {:internal_server_error, "internal server error"}, conn}
    |> Text.encode_response()
    |> Http.send(:ignore, conn)
  end
end
