defmodule Shortnr.Application do
  @moduledoc """
  The Shortnr application entry point. Check README for usage documenation.
  """

  require Logger
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Shortnr.Router, options: [port: port()]}
    ]

    if ets_implementation() == :dets do
      {:ok, _} = :dets.open_file(:urls, type: :set)
    else
      :ets.new(:urls, [:set, :named_table])
    end

    Logger.info("server starting", port: port())

    opts = [strategy: :one_for_one, name: Shortnr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl Application
  def stop(_state) do
    if ets_implementation() == :dets, do: :dets.close(:urls)
  end

  @spec port() :: integer()
  defp port do
    {:ok, port} = Application.fetch_env(:shortnr, :port)
    port
  end

  @spec ets_implementation() :: atom()
  defp ets_implementation do
    {:ok, impl} = Application.fetch_env(:shortnr, :ets_implementation)
    impl
  end
end
