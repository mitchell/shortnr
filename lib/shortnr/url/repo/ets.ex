defmodule Shortnr.URL.Repo.ETS do
  @moduledoc """
  This module is an implemention of the Repo behaviour using the Erlang ETS library.
  """

  def get(key) do
    case ets().lookup(:urls, key) |> List.first() do
      {_, url} -> {:ok, url}
      nil -> {:ok, nil}
    end
  end

  def put(url) do
    :ok = ets().insert(:urls, {url.id, url})
    :ok
  end

  def list do
    resp = ets().select(:urls, [{:"$1", [], [:"$1"]}])
    {:ok, resp |> Enum.map(&elem(&1, 1))}
  end

  def delete(key) do
    :ok = ets().delete(:urls, key)
    :ok
  end

  def reset do
    :ok = ets().delete_all_objects(:urls)
  end

  defp ets do
    {:ok, impl} = Application.fetch_env(:shortnr, :ets_implementation)
    impl
  end
end
