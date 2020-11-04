defmodule DeliveryParserWeb.ParserController do
  use DeliveryParserWeb, :controller
  alias DeliveryParserWeb.PayloadValidator
  alias DeliveryParser.OrderAdapter

  @url "https://delivery-center-recruitment-ap.herokuapp.com/"

  plug :validate

  def parse(%{body_params: payload} = conn, _params) do
    order = payload
      |> OrderAdapter.adapt
      |> IO.inspect

    case send order do
      {:ok, %{body: "OK"}} -> json(conn, %{ok: true, data: order})
      {:ok, response} -> json(conn, %{ok: false, error: response.body})
      {:error, error} -> json(conn, %{ok: false, error: error.reason})
    end
  end

  defp validate(%{body_params: payload} = conn, _params) do
    case PayloadValidator.valid? payload do
      :ok -> conn
      {:error, errors} ->
        json(conn, %{ok: false, error: Enum.join(errors, "\n")}) |> halt()
    end
  end

  defp send(order) do
    response =
      HTTPoison.post @url,
      Jason.encode!(order),
      [{"Content-Type", "application/json"}, {"X-Sent", x_sent_header()}]

    IO.inspect response
  end

  defp x_sent_header do

  end
end