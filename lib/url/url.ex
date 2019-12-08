defmodule Shortnr.URL do
  alias Shortnr.Transport
  alias Shortnr.URL

  defstruct id:
              for(
                _ <- 0..7,
                into: "",
                do:
                  Enum.random(
                    String.codepoints(
                      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXWYZ0123456789"
                    )
                  )
              ),
            created_at: DateTime.utc_now(),
            updated_at: DateTime.utc_now(),
            url: %URI{}

  @type t :: %__MODULE__{id: String.t(), url: URI.t()}

  @spec create(String.t(), module()) :: {:ok, String.t()} | Transport.error()
  def create(url, repo) do
    url_struct = %URL{url: URI.parse(url)}
    :ok = repo.put(url_struct)
    {:ok, url_struct.id}
  end

  @spec get(String.t(), module()) :: {:ok, URL.t()} | Transport.error()
  def get(key, repo) do
    {:ok, _} = repo.get(key)
  end

  @spec list(module()) :: {:ok, list(URL.t())} | Transport.error()
  def list(repo) do
    {:ok, _} = repo.list
  end

  defimpl String.Chars do
    alias Shortnr.URL
    @spec to_string(URL.t()) :: String.t()
    def to_string(url) do
      "id=#{url.id} created=#{url.created_at} updated=#{url.updated_at} url=#{url.url}"
    end
  end
end
