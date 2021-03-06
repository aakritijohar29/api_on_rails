require 'rails_helper'

RSpec.describe Product, type: :model do
  
  let(:product) { FactoryGirl.build :product }
  #subject(:product) { product }

  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:published) }
  it { should respond_to(:user_id) }

  it { should_not be_published }

  it { should validate_presence_of :title }
  it { should validate_presence_of :price }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of :price }
  it { should belong_to :user }

  it { should have_many(:placements) }
  it { should have_many(:orders).through(:placements) }

  describe ".filter_by_title" do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: "Ford Focus"
      @product2 = FactoryGirl.create :product, title: "Tesla model S"
      @product3 = FactoryGirl.create :product, title: "Toyota Prius"
      @product4 = FactoryGirl.create :product, title: "Tesla model X"
    end

    context "When a 'Tesla' pattern is sent" do

      it "returns the 2 products matching" do
        expect(Product.filter_by_title("Tesla").size).to eql 2
      end

      it "returns the products matching" do
        expect(Product.filter_by_title("Tesla")).to match_array([@product2, @product4])
      end

    end
  end

  describe ".above_or_equal_to_price" do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99
    end

    it "returns the products which are above or equal to the price" do
      expect(Product.above_or_equal_to_price(100).sort).to match_array([@product1, @product3])
    end
  end

  describe ".below_or_equal_to_price" do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99
    end

    it "returns the products which are below or equal to the price" do
      expect(Product.below_or_equal_to_price(99).sort).to match_array([@product2, @product4])
    end
  end

  describe ".recent" do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99

      #touch the products to update them
      @product2.touch
      @product3.touch
    end

    it "returns the most updated records" do
      expect(Product.recent).to match_array([@product3, @product2, @product4, @product1])
    end
  end

  describe "search" do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100,  title: "Ford Focus"
      @product2 = FactoryGirl.create :product, price: 50,   title: "Tesla model S"
      @product3 = FactoryGirl.create :product, price: 150,  title: "Toyota Prius"
      @product4 = FactoryGirl.create :product, price: 99,   title: "Tesla model X"
    end

    context "when title 'tesla' and '120' a min price are set" do
      
      it "returns an empty array" do
        search_hash = { keyword: "tesla", min_price: 120 }
        expect(Product.search(search_hash)).to be_empty
      end
    end

    context "when title 'ford', '150' as max price and '50' as min price are set" do
      it "returns the product1" do
        search_hash = { keyword: "ford", max_price: 150, min_price: 50 }
        expect(Product.search(search_hash)).to match_array([@product1])
      end
    end

    context "when a empty hash is sent" do
      it "returns all the products" do
        expect(Product.search({})).to match_array([@product1, @product2, @product3, @product4])
      end
    end

    context "when product_ids is present" do
      it "returns the product from the ids" do
        search_hash = { product_ids: [@product1.id, @product2.id] }
        expect(Product.search(search_hash)).to match_array([@product1, @product2])
      end
    end

  end

end










