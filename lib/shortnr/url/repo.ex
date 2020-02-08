defmodule Shortnr.URL.Repo do
  @moduledoc """
  This module defines the Repo behaviour for the URL service. All Repos must implement this
  entire behaviour.
  """

  alias Shortnr.Transport
  alias Shortnr.URL

  @callback put(URL.t()) :: :ok | Transport.error()
  @callback get(String.t()) :: {:ok, URL.t()} | Transport.error()
  @callback delete(String.t()) :: :ok | Transport.error()
  @callback list() :: {:ok, list(URL.t())} | Transport.error()
  @callback reset() :: :ok | Transport.error()
end
