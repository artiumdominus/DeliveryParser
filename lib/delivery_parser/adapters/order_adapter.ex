defmodule DeliveryParser.OrderAdapter do
  def adapt(payload) do
    %{
      externalCode:  Integer.to_string(payload["id"]),
      storeId:       payload["store_id"],
      subTotal:      Float.to_string(payload["total_amount"]),
      deliveryFee:   Float.to_string(payload["total_shipping"]),
      total:         Float.to_string(payload["total_amount_with_shipping"]),
      country:       payload["shipping"]["receiver_address"]["country"]["id"],
      state:         infer_state(payload["shipping"]["receiver_address"]["state"]["name"]),
      city:          payload["shipping"]["receiver_address"]["city"]["name"],
      district:      payload["shipping"]["receiver_address"]["neighborhood"]["name"],
      street:        payload["shipping"]["receiver_address"]["street_name"],
      complement:    "galpao",
      latitude:      payload["shipping"]["receiver_address"]["latitude"],
      longitude:     payload["shipping"]["receiver_address"]["longitude"],
      dtOrderCreate: DateTime.to_string(DateTime.utc_now),
      postalCode:    payload["shipping"]["receiver_address"]["zip_code"],
      number:        0,
      customer:      get_customer(payload),
      items:         Enum.map(payload["order_items"], &adapt_item/1),
      payments:      Enum.map(payload["payments"], &adapt_payment/1),
      total_shipping: payload["total_shipping"]
    }
  end

  def get_customer(payload) do
    %{
      externalCode: payload["buyer"]["id"],
      name:         payload["buyer"]["nickname"],
      email:        payload["buyer"]["email"],
      contact:      Integer.to_string(payload["buyer"]["phone"]["area_code"]) <>
                                        payload["buyer"]["phone"]["number"],
    }
  end

  def adapt_item(item) do
    %{
      externalCode: item["item"]["id"],
      name:         item["item"]["title"],
      price:        item["unit_price"],
      quantity:     item["quantity"],
      total:        item["full_unit_price"],
      subitems:     []
    }
  end

  def adapt_payment(payment) do
    %{
      type: String.upcase(payment["payment_type"]),
      value: payment["total_paid_amount"]
    }
  end

  def infer_state(state_name) do
    case state_name do
      "Acre"                -> "AC"
      "Alagoas"             -> "AL"
      "Amapá"               -> "AP"
      "Amazonas"            -> "AM"
      "Bahia"               -> "BA"
      "Ceará"               -> "CE"
      "Distrito Federal"    -> "DF"
      "Espirito Santo"      -> "ES"
      "Goiás"               -> "GO"
      "Maranhão"            -> "MA"
      "Mato Grosso"         -> "MT"
      "Mato Grosso do Sul"  -> "MS"
      "Minas Gerais"        -> "MG"
      "Pará"                -> "PA"
      "Paraíba"             -> "PB"
      "Paraná"              -> "PR"
      "Pernambuco"          -> "PE"
      "Piauí"               -> "PI"
      "Rio de Janeiro"      -> "RJ"
      "Rio Grande do Norte" -> "RN"
      "Rio Grande do Sul"   -> "RS"
      "Rondônia"            -> "RO"
      "Roraima"             -> "RR"
      "Santa Catarina"      -> "SC"
      "São Paulo"           -> "SP"
      "Sergipe"             -> "SE"
      "Tocantins"           -> "TO"
    end
  end
end