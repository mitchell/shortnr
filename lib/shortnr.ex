defmodule Shortnr do
  @moduledoc """
  The Shortnr application entry point. Check README for usage documenation.
  """

  require Logger
  use Application

  @impl true
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
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @impl true
  def stop(_state) do
    if ets_implementation() == :dets, do: :dets.close(:urls)
  end

  @spec port() :: integer()
  defp port do
    case Application.fetch_env(:shortnr, :port) do
      {:ok, port} -> port
      _ -> 4000
    end
  end

  @spec ets_implementation() :: atom()
  defp ets_implementation, do: Application.fetch_env!(:shortnr, :ets_implementation)
end
