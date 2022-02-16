defmodule Sneakers23Web.ProductChannelTest do

  use Sneakers23Web.ChannelCase, async: true
  #import Sneakers23Web.ChannelCase
  alias Sneakers23Web.{Endpoint, ProductChannel}
  alias Sneakers23.Inventory.CompleteProduct

  describe "notify product released" do
    test "the size selector for the product is broadcast" do
      {inventory, _data} = Test.Factory.InventoryFactory.complete_products()
      [_, product] = CompleteProduct.get_complete_products(inventory)

      topic = "product:#{product.id}"
      Endpoint.subscribe(topic)

      ProductChannel.notify_product_released(product)

      assert_broadcast "released", %{size_html: html}

      assert html =~ "size-container__entry"

      Enum.each(product.items, fn item ->
        assert html =~ ~s(value="#{item.id}")
      end)
    end
  end

end