defmodule Shortnr.Router do
  use Plug.ErrorHandler
  use Plug.Router

  require Logger

  alias Shortnr.Transport.{Text, HTTP}
  alias Shortnr.URL

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  post "/urls/:url" do
    {:ok, url, conn}
    |> HTTP.handle(&URL.create(&1, URL.Repo.ETS))
    |> Text.encode_response()
    |> HTTP.send(:created, conn)
  end

  get "/urls" do
    {:ok, :ignore, conn}
    |> HTTP.handle(fn -> URL.list(URL.Repo.ETS) end)
    |> Text.encode_response()
    |> HTTP.send(:ok, conn)
  end

  get "/:id" do
    {:ok, id, conn}
    |> HTTP.handle(&URL.get(&1, URL.Repo.ETS))
    |> Text.encode_response()
    |> HTTP.send(:found, conn)
  end

  delete "/:id" do
    {:ok, id, conn}
    |> HTTP.handle(&URL.delete(&1, URL.Repo.ETS))
    |> Text.encode_response()
    |> HTTP.send(:ok, conn)
  end

  match _ do
    {:error, {:not_found, "route not found"}, conn}
    |> Text.encode_response()
    |> HTTP.send(:ignore, conn)
  end

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: stack}) do
    Logger.error(reason, stack: stack)

    {:error, {:internal_server_error, "internal server error"}, conn}
    |> Text.encode_response()
    |> HTTP.send(:ignore, conn)
  end
end
