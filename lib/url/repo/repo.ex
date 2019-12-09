defmodule Shortnr.URL.Repo do
  alias Shortnr.URL
  alias Shortnr.Transport

  @callback put(URL.t()) :: :ok | Transport.error()
  @callback get(String.t()) :: {:ok, URL.t()} | Transport.error()
  @callback delete(String.t()) :: :ok | Transport.error()
  @callback list() :: {:ok, list(URL.t())} | Transport.error()
end
