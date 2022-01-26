defmodule Shortnr.URL do
  @moduledoc """
  This module represents both the URL data object, in the form of a struct, and the URL business
  domain service.
  """
  alias Shortnr.Transport
  alias Shortnr.URL.Repo

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

  @spec create(String.t()) :: {:ok, String.t()} | Transport.error()
  def create(url) when is_binary(url) do
    url_struct = %__MODULE__{id: generate_id(), url: URI.parse(url)}

    url_struct.id
    |> Repo.get()
    |> create_if_no_collision(url_struct, url)
  end

  defp create_if_no_collision({:ok, nil}, %__MODULE__{id: id} = url, _url) do
    :ok = Repo.put(url)
    {:ok, id}
  end

  defp create_if_no_collision({:ok, _}, _url_struct, url) when is_binary(url), do: create(url)

  @spec get(String.t()) :: {:ok, t()} | Transport.error()
  def get(key) do
    key
    |> Repo.get()
    |> handle_errors
  end

  @spec list() :: {:ok, list(t())}
  def list do
    handle_errors(Repo.list())
  end

  @spec delete(String.t()) :: {:ok, String.t()}
  def delete(key) do
    key
    |> Repo.delete()
    |> handle_errors
  end

  @id_chars String.codepoints("abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXWYZ0123456789")
  @spec generate_id() :: String.t()
  def generate_id do
    for _ <- 0..7,
        into: "",
        do: Enum.random(@id_chars)
  end

  defp handle_errors({:ok, nil}),
    do: {:error, {:not_found, "url could not be found with the given id"}}

  defp handle_errors({:ok, _} = response), do: response

  defp handle_errors(:ok), do: {:ok, "Success"}

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
