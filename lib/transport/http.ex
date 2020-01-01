defmodule Shortnr.Transport.HTTP do
  @moduledoc """
  This module contains functions that can be used to handle HTTP requests and send responses, by
  manipulating Plug.Conn.
  """
  alias Shortnr.Transport
  import Plug.Conn

  @type error :: {:error, {atom(), String.t()}, Plug.Conn.t()}
  @type ok_error :: {:ok, term(), Plug.Conn.t()} | error()

  @spec wrap(Plug.Conn.t(), term()) :: ok_error
  def wrap(conn, argument \\ nil)
  def wrap(conn, nil), do: {:ok, nil, conn}
  def wrap(conn, {first, _second} = argument) when is_atom(first), do: {:error, argument, conn}
  def wrap(conn, argument), do: {:ok, argument, conn}

  @spec handle(ok_error(), (term() -> Transport.ok_error()) | (() -> Transport.ok_error())) ::
          ok_error()
  def handle(error = {:error, _sub_error, _conn}, _func), do: error

  def handle({:ok, request, conn}, func) when is_function(func, 1) do
    case func.(request) do
      {:ok, response} -> {:ok, response, conn}
      {:error, error_value} -> convert_error(error_value, conn)
    end
  end

  def handle({:ok, _request, conn}, func) when is_function(func, 0) do
    case func.() do
      {:ok, response} -> {:ok, response, conn}
      {:error, error_value} -> convert_error(error_value, conn)
    end
  end

  defp convert_error({:invalid_argument, message}, conn),
    do: {:error, {:bad_request, message}, conn}

  defp convert_error({:not_found, message}, conn),
    do: {:error, {:not_found, message}, conn}

  defp convert_error(_, conn), do: {:error, {:internal_server_error, "unknown error"}, conn}

  @spec send(ok_error(), atom()) :: Plug.Conn.t()
  def send(ok_error, success_status \\ nil)

  def send({:error, {status, body}, conn}, _success_status) do
    send_resp(conn, status_to_code(status), body)
  end

  def send({:ok, location, conn}, :found) do
    conn = put_resp_header(conn, "Location", location)
    send_resp(conn, status_to_code(:found), location)
  end

  def send({:ok, body, conn}, success_status) do
    send_resp(conn, status_to_code(success_status), body)
  end

  defp status_to_code(:ok), do: 200
  defp status_to_code(:created), do: 201
  defp status_to_code(:found), do: 302
  defp status_to_code(:bad_request), do: 400
  defp status_to_code(:not_found), do: 404
  defp status_to_code(:internal_server_error), do: 500
end
