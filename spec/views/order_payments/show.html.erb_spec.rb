require 'spec_helper'

describe "order_payments/show.html.erb" do
  before(:each) do
    @order_payment = assign(:order_payment, stub_model(OrderPayment,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/City/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Postal/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Card Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Card No/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Authorization/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Order/)
  end
end
