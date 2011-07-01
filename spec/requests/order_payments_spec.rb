require 'spec_helper'

describe "OrderPayments" do
  describe "GET /order_payments" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get order_payments_path
      response.status.should be(200)
    end
  end
end
