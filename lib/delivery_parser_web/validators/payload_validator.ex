defmodule DeliveryParserWeb.PayloadValidator do
  def valid?(payload) do
    Skooma.valid? payload,
      %{
        "id" => :number,
        "store_id" => :number,
        "total_amount" => :number,
        "total_shipping" => :number,
        "total_amount_with_shipping" => :number,
        "shipping" => %{
          "receiver_address" => %{
            "country" => %{"id" => :string},
            "state" => %{"name" => :string},
            "city" => %{"name" => :string},
            "neighborhood" => %{"name" => :string},
            "street_name" => :string,
            "latitude" => :number,
            "longitude" => :number,
            "zip_code" => :string
          },
        },
        "buyer" => %{
          "id" => :number,
          "first_name" => :string,
          "last_name" => :string,
          "email" => :string,
          "phone" => %{
            "area_code" => :number,
            "number" => :string
          }
        },
        "order_items" => [:list, :map, %{
          "item" => %{
            "id" => :string,
            "title" => :string
          },
          "unit_price" => :number,
          "quantity" => :number,
          "full_unit_price" => :number
        }],
        "payments" => [:list, :map, %{
          "payment_type" => :string,
          "total_paid_amount" => :number
        }]
      }
  end
end