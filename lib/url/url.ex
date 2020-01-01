defmodule Shortnr.URL do
  @moduledoc """
  This module represents both the URL data object, in the form of a struct, and the URL business
  domain service.
  """
  alias Shortnr.Transport
  alias Shortnr.URL.Util

  defstruct id: "",
            created_at: DateTime.utc_now(),
            updated_at: DateTime.utc_now(),
            url: %URI{}

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: DateTime.t(),
          updated_at: DateTime.t(),
          url: URI.t()
        }

  @spec create(String.t(), module()) :: {:ok, String.t()} | Transport.error()
  def create(url, repo) do
    url_struct = %__MODULE__{id: Util.generate_id(), url: URI.parse(url)}

    {:ok, extant_url} = repo.get(url_struct.id)

    if extant_url do
      create(url, repo)
    else
      :ok = repo.put(url_struct)
      {:ok, url_struct.id}
    end
  end

  @spec get(String.t(), module()) :: {:ok, t()} | Transport.error()
  def get(key, repo) do
    case repo.get(key) do
      {:ok, nil} -> {:error, {:not_found, "url could not be found with the given id"}}
      {:ok, url} -> {:ok, url}
    end
  end

  @spec list(module()) :: {:ok, list(t())} | Transport.error()
  def list(repo) do
    {:ok, _} = repo.list
  end

  @spec delete(String.t(), module()) :: {:ok, String.t()} | Transport.error()
  def delete(key, repo) do
    :ok = repo.delete(key)
    {:ok, "Success"}
  end

  defimpl Transport.Text.Encodable do
    alias Shortnr.URL
    @spec encode(URL.t()) :: String.t()
    def encode(url), do: URI.to_string(url.url)
  end

  defimpl String.Chars do
    alias Shortnr.URL
    @spec to_string(URL.t()) :: String.t()
    def to_string(url) do
      "id=#{url.id} created_at=#{url.created_at} updated_at=#{url.updated_at} url=#{url.url}"
    end
  end
end
