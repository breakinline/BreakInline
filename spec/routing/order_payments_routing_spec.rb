require "spec_helper"

describe OrderPaymentsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/order_payments" }.should route_to(:controller => "order_payments", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/order_payments/new" }.should route_to(:controller => "order_payments", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/order_payments/1" }.should route_to(:controller => "order_payments", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/order_payments/1/edit" }.should route_to(:controller => "order_payments", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/order_payments" }.should route_to(:controller => "order_payments", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/order_payments/1" }.should route_to(:controller => "order_payments", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/order_payments/1" }.should route_to(:controller => "order_payments", :action => "destroy", :id => "1")
    end

  end
end
