require 'spec_helper'

describe "order_payments/edit.html.erb" do
  before(:each) do
    @order_payment = assign(:order_payment, stub_model(OrderPayment,
      :name => "MyString",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :postal => "MyString",
      :phone => "MyString",
      :cardType => "MyString",
      :cardNo => "MyString",
      :expirationMonth => "",
      :expirationYear => "",
      :authorization => "MyString",
      :orderId => "MyString"
    ))
  end

  it "renders the edit order_payment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => order_payments_path(@order_payment), :method => "post" do
      assert_select "input#order_payment_name", :name => "order_payment[name]"
      assert_select "input#order_payment_address", :name => "order_payment[address]"
      assert_select "input#order_payment_city", :name => "order_payment[city]"
      assert_select "input#order_payment_state", :name => "order_payment[state]"
      assert_select "input#order_payment_postal", :name => "order_payment[postal]"
      assert_select "input#order_payment_phone", :name => "order_payment[phone]"
      assert_select "input#order_payment_cardType", :name => "order_payment[cardType]"
      assert_select "input#order_payment_cardNo", :name => "order_payment[cardNo]"
      assert_select "input#order_payment_expirationMonth", :name => "order_payment[expirationMonth]"
      assert_select "input#order_payment_expirationYear", :name => "order_payment[expirationYear]"
      assert_select "input#order_payment_authorization", :name => "order_payment[authorization]"
      assert_select "input#order_payment_orderId", :name => "order_payment[orderId]"
    end
  end
end
