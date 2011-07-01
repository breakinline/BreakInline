require 'spec_helper'

describe "order_payments/index.html.erb" do
  before(:each) do
    assign(:order_payments, [
      stub_model(OrderPayment,
        :name => "Name",
        :address => "Address",
        :city => "City",
        :state => "State",
        :postal => "Postal",
        :phone => "Phone",
        :cardType => "Card Type",
        :cardNo => "Card No",
        :expirationMonth => "",
        :expirationYear => "",
        :authorization => "Authorization",
        :orderId => "Order"
      ),
      stub_model(OrderPayment,
        :name => "Name",
        :address => "Address",
        :city => "City",
        :state => "State",
        :postal => "Postal",
        :phone => "Phone",
        :cardType => "Card Type",
        :cardNo => "Card No",
        :expirationMonth => "",
        :expirationYear => "",
        :authorization => "Authorization",
        :orderId => "Order"
      )
    ])
  end

  it "renders a list of order_payments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "City".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Postal".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Card Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Card No".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Authorization".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Order".to_s, :count => 2
  end
end
