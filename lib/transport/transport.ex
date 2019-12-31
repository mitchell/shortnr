defmodule Shortnr.Transport do
  @moduledoc """
  This module houses generic Transport types.
  """
  @type error :: {:error, {atom(), String.t()}}
  @type ok_error :: {:ok, term()} | error()
end
