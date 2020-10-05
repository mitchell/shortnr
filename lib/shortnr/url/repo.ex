defmodule Shortnr.URL.Repo do
  @moduledoc """
  This module defines the Repo behaviour for the URL service. All Repos must implement this
  entire behaviour.
  """

  alias Shortnr.Transport
  alias Shortnr.URL

  @spec put(URL.t()) :: :ok | Transport.error()
  defdelegate put(url), to: Shortnr.URL.Repo.ETS

  @spec get(String.t()) :: {:ok, URL.t() | nil} | Transport.error()
  defdelegate get(url), to: Shortnr.URL.Repo.ETS

  @spec delete(String.t()) :: :ok | Transport.error()
  defdelegate delete(url), to: Shortnr.URL.Repo.ETS

  @spec list() :: {:ok, list(URL.t())} | Transport.error()
  defdelegate list(), to: Shortnr.URL.Repo.ETS

  @spec reset() :: :ok | Transport.error()
  defdelegate reset(), to: Shortnr.URL.Repo.ETS
end
