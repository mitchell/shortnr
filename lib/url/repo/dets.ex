defmodule Shortnr.URL.Repo.DETS do
  @behaviour Shortnr.URL.Repo

  @impl true
  def get(key) do
    case :dets.lookup(:urls, key) |> List.first() do
      {_, url} -> {:ok, url}
      nil -> {:ok, nil}
    end
  end

  @impl true
  def put(url) do
    :ok = :dets.insert(:urls, {url.id, url})
    :ok
  end

  @impl true
  def list() do
    resp = :dets.select(:urls, [{:"$1", [], [:"$1"]}])
    {:ok, resp |> Enum.map(&elem(&1, 1))}
  end

  @impl true
  def delete(key) do
    :ok = :dets.delete(:urls, key)
    :ok
  end
end
