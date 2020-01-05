defmodule Shortnr.URL.Repo.ETS do
  @moduledoc """
  This module is an implemention of the Repo behaviour using the Erlang ETS library.
  """
  alias Shortnr.URL.Repo

  @behaviour Repo

  @impl Repo
  def get(key) do
    case ets().lookup(:urls, key) |> List.first() do
      {_, url} -> {:ok, url}
      nil -> {:ok, nil}
    end
  end

  @impl Repo
  def put(url) do
    :ok = ets().insert(:urls, {url.id, url})
    :ok
  end

  @impl Repo
  def list do
    resp = ets().select(:urls, [{:"$1", [], [:"$1"]}])
    {:ok, resp |> Enum.map(&elem(&1, 1))}
  end

  @impl Repo
  def delete(key) do
    :ok = ets().delete(:urls, key)
    :ok
  end

  @impl Repo
  def reset do
    :ok = ets().delete_all_objects(:urls)
  end

  defp ets, do: Application.fetch_env!(:shortnr, :ets_implementation)
end
