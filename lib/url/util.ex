defmodule Shortnr.URL.Util do
  @id_chars String.codepoints("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXWYZ0123456789")
  @spec gen_id() :: String.t()
  def gen_id do
    for _ <- 0..7,
        into: "",
        do: Enum.random(@id_chars)
  end
end
