defmodule Shortnr.Transport.Http do
  import Plug.Conn

  @type ok_error :: {:ok, term(), Plug.Conn.t()} | error()
  @type error :: {:error, {atom(), String.t()}, Plug.Conn.t()}

  @spec handle(ok_error(), (term() -> ok_error())) :: ok_error()
  def handle(error = {:error, _sub_error, _conn}, _func), do: error

  def handle({:ok, request, conn}, func) do
    case func.(request) do
      {:ok, response} -> {:ok, response, conn}
      {:error, error_value} -> convert_error(error_value, conn)
    end
  end

  defp convert_error({:invalid_argument, message}, conn),
    do: {:error, {:bad_request, message}, conn}

  defp convert_error(_, conn), do: {:error, {:internal_server_error, "unknown error"}, conn}

  @spec send(ok_error(), atom(), Plug.Conn.t()) :: Plug.Conn.t()
  def send({:error, {status, body}, _conn}, _success_status, original_conn) do
    send_resp(original_conn, status_to_code(status), body)
  end

  def send({:ok, body, conn}, success_status, _original_conn) do
    send_resp(conn, status_to_code(success_status), body)
  end

  defp status_to_code(:ok), do: 200
  defp status_to_code(:created), do: 201
  defp status_to_code(:bad_request), do: 400
  defp status_to_code(:not_found), do: 404
  defp status_to_code(:internal_server_error), do: 500
end
