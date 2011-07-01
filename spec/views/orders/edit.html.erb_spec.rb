require 'spec_helper'

describe "orders/edit.html.erb" do
  before(:each) do
    @order = assign(:order, stub_model(Order,
      :profileId => "",
      :locationId => "",
      :status => "MyString",
      :subTotal => "9.99",
      :taxTotal => "9.99",
      :total => "9.99",
      :comment => "MyString"
    ))
  end

  it "renders the edit order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => orders_path(@order), :method => "post" do
      assert_select "input#order_profileId", :name => "order[profileId]"
      assert_select "input#order_locationId", :name => "order[locationId]"
      assert_select "input#order_status", :name => "order[status]"
      assert_select "input#order_subTotal", :name => "order[subTotal]"
      assert_select "input#order_taxTotal", :name => "order[taxTotal]"
      assert_select "input#order_total", :name => "order[total]"
      assert_select "input#order_comment", :name => "order[comment]"
    end
  end
end
