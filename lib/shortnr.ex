defmodule Shortnr do
  @moduledoc """
  Documentation for Shortnr.
  """

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    port = port()

    children = [
      {Plug.Cowboy, scheme: :http, plug: Shortnr.Router, options: [port: port]}
    ]

    Logger.info("server starting", port: port)
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @spec port() :: integer()
  defp port do
    case Application.fetch_env(:service, :port) do
      {:ok, port} -> port
      _ -> 4000
    end
  end
end
