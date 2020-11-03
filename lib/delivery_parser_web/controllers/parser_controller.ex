defmodule DeliveryParserWeb.ParserController do
  use DeliveryParserWeb, :controller
  alias DeliveryParserWeb.PayloadValidator
  alias DeliveryParser.OrderAdapter

  @url "https://delivery-center-recruitment-ap.herokuapp.com/"

  plug :observe
  plug :validate

  def parse(%{body_params: payload} = conn, _params) do
    order = payload
      |> OrderAdapter.adapt
      |> IO.inspect
    
    response = send order

    case response do
      {:ok, response} ->
        if response.body == "OK" do
          json(conn, %{ok: true, data: order})
        else
          json(conn, %{ok: false, error: response.body})
        end
      {:error, error} -> json(conn, %{ok: false, error: error.reason})
    end
  end

  defp observe(%{body_params: payload} = conn, _params) do
    IO.inspect payload

    conn
  end

  defp validate(%{body_params: payload} = conn, _params) do
    case PayloadValidator.valid? payload do
      :ok -> conn
      {:error, errors} -> json(conn, %{ok: false, errors: errors}) |> halt()
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