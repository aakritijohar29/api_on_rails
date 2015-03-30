require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns the information about a product on a hash" do
      #json_response function was defined in the Request::JsonHelpers module (support foulder)
      product_response = json_response[:product]
      expect(product_response[:title]).to eql @product.title
    end

    it "has the user as a embeded object" do
      product_response = json_response[:product]
      expect(product_response[:user][:email]).to eql @product.user.email
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
    end

    context "when is not receiving any product_ids parameter" do
      before(:each) do
        get :index
      end

      it "returns 4 records from database" do
        products_response = json_response
        # Collection cardinalities matchers have(x).items, have_at_least(x).items,
        # and have_at_most(x).items were extracted into the rspec-collection-matchers gem
        #link: http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/
        expect(products_response[:products].size).to eql 4
      end

      it "returns the user object into each product" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end

      #pagination
      it { expect(json_response).to have_key(:meta) }
      it { expect(json_response[:meta]).to have_key(:pagination) }
      it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
      it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
      it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }

      it { should respond_with 200 }
    end

    context "when product_ids parameter is sent" do
      before(:each) do
        @user = FactoryGirl.create :user
        3.times { FactoryGirl.create :product, user: @user }
        get :index, product_ids: @user.product_ids
      end

      it "returns just the products that belong to the user" do
        products_response = json_response[:products]
        products_response.each do |product|
          expect(product[:user][:email]).to eql @user.email
        end
      end

    end

  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @product_attributes }
      end

      it "renders the json representation for the product record just created" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: "Tesla Model X", price: "fifty thousand dollars" }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @invalid_product_attributes }
      end

      it "renders an errors json message" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the json errors on why user could not create the product" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  #next description
  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, title: "Tesla Model X 2015" }
      end

      it "renders the JSON representation for the updated product" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql "Tesla Model X 2015"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, product: { price: "two hundred" } }
      end

      it "renders an error JSON response" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the JSON error on why the product could not be updated" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, { user_id: @user.id, id: @product.id }
    end

    it { should respond_with 204 }
  end

end











