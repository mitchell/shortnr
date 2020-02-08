defmodule Shortnr.URL.Util do
  @moduledoc """
  URL module utility functions.
  """
  @id_chars String.codepoints("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXWYZ0123456789")
  @spec generate_id() :: String.t()
  def generate_id do
    for _ <- 0..7,
        into: "",
        do: Enum.random(@id_chars)
  end
end
