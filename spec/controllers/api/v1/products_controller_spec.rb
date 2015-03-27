require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns the information about a product on a hash" do
      #json_response function was defined in the Request::JsonHelpers module (support foulder)
      product_response = json_response
      expect(product_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
      get :index
    end

    it "returns 4 records from database" do
      products_response = json_response
      # Collection cardinalities matchers have(x).items, have_at_least(x).items,
      # and have_at_most(x).items were extracted into the rspec-collection-matchers gem
      #link: http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/
      expect(products_response[:products].size).to eql 4
    end

    it { should respond_with 200 }

  end

end











