defmodule Shortnr.Transport do
  @type error :: {:error, {atom(), String.t()}}
  @type ok_error :: {:ok, term()} | error()
end
