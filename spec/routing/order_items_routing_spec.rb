require "spec_helper"

describe OrderItemsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/order_items" }.should route_to(:controller => "order_items", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/order_items/new" }.should route_to(:controller => "order_items", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/order_items/1" }.should route_to(:controller => "order_items", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/order_items/1/edit" }.should route_to(:controller => "order_items", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/order_items" }.should route_to(:controller => "order_items", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/order_items/1" }.should route_to(:controller => "order_items", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/order_items/1" }.should route_to(:controller => "order_items", :action => "destroy", :id => "1")
    end

  end
end
