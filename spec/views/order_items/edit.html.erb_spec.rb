require 'spec_helper'

describe "order_items/edit.html.erb" do
  before(:each) do
    @order_item = assign(:order_item, stub_model(OrderItem,
      :menuItemId => "",
      :price => "9.99",
      :quantity => "",
      :comment => "MyString",
      :orderId => "",
      :itemType => "",
      :parentOrderItemId => ""
    ))
  end

  it "renders the edit order_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => order_items_path(@order_item), :method => "post" do
      assert_select "input#order_item_menuItemId", :name => "order_item[menuItemId]"
      assert_select "input#order_item_price", :name => "order_item[price]"
      assert_select "input#order_item_quantity", :name => "order_item[quantity]"
      assert_select "input#order_item_comment", :name => "order_item[comment]"
      assert_select "input#order_item_orderId", :name => "order_item[orderId]"
      assert_select "input#order_item_itemType", :name => "order_item[itemType]"
      assert_select "input#order_item_parentOrderItemId", :name => "order_item[parentOrderItemId]"
    end
  end
end
