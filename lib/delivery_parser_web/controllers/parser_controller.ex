defmodule DeliveryParserWeb.ParserController do
  use DeliveryParserWeb, :controller
  alias DeliveryParserWeb.PayloadValidator
  alias DeliveryParser.OrderAdapter

  @url "https://delivery-center-recruitment-ap.herokuapp.com/"

  plug :validate

  def parse(%{body_params: payload} = conn, _params) do
    order = OrderAdapter.adapt payload

    result = case send order do
      {:ok, %{body: "OK"}} -> %{ok: true, data: order}
      {:ok, response} -> %{ok: false, error: response.body}
      {:error, error} -> %{ok: false, error: error.reason}
    end

    json(conn, result)
  end

  defp validate(%{body_params: payload} = conn, _params) do
    case PayloadValidator.valid? payload do
      :ok -> conn
      {:error, errors} ->
        json(conn, %{ok: false, error: Enum.join(errors, "\n")}) |> halt()
    end
  end

  defp send(order) do
    HTTPoison.post @url,
      Jason.encode!(order),
      [{"Content-Type", "application/json"}, {"X-Sent", x_sent()}]
  end

  defp x_sent do
    Timex.now("America/Sao_Paulo")
    |> Timex.format!("{h24}h{m} - {0D}/{0M}/{YY}")
  end
end