require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do


  describe "GET #show" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, user_id: current_user.id
    end

    it "returns 4 order records from the current user" do
      orders_response = json_response[:orders]
      expect(orders_response.size).to eql 4
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      @order = FactoryGirl.create :order, user: current_user
      get :show, user_id: current_user.id, id: @order.id
    end

    it "returns the user order record matching the ID" do
      order_response = json_response[:order]
      expect(order_response[:id]).to eql @order.id
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header(current_user.auth_token)
      @product = FactoryGirl.create :product
      @order = FactoryGirl.create :order, user: current_user, product_ids: [@product.id]
      get :show, user_id: current_user.id, id: @order.id
    end

    it "includes the total for the order" do
      order_response = json_response[:order]
      expect(order_response[:total]).to eql @order.total
    end

    it "includes the products on the order" do
      order_response = json_response[:order]
      expect(order_response[:products].size).to eql 1
    end
  end

  describe "POST #create" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      product1 = FactoryGirl.create :product, user: current_user
      product2 = FactoryGirl.create :product, user: current_user
      order_params = { product_ids: [product1.id, product2.id] }
      post :create, user_id: current_user.id, order: order_params
    end

    it "returns just the user order record" do
      order_response = json_response[:order]
      expect(order_response[:id]).to be_present
    end

    it { should respond_with 201 }
  end

end















