require 'spec_helper'

describe "order_items/index.html.erb" do
  before(:each) do
    assign(:order_items, [
      stub_model(OrderItem,
        :menuItemId => "",
        :price => "9.99",
        :quantity => "",
        :comment => "Comment",
        :orderId => "",
        :itemType => "",
        :parentOrderItemId => ""
      ),
      stub_model(OrderItem,
        :menuItemId => "",
        :price => "9.99",
        :quantity => "",
        :comment => "Comment",
        :orderId => "",
        :itemType => "",
        :parentOrderItemId => ""
      )
    ])
  end

  it "renders a list of order_items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
