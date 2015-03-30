require 'rails_helper'

RSpec.describe Order, type: :model do
  
  let(:order) { FactoryGirl.build :order }

  it { should respond_to(:total) }
  it { should respond_to(:user_id) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:total) }
  it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }

  it { should belong_to(:user) }

  it { should have_many(:placements) }
  it { should have_many(:products).through(:placements) }

  describe ".set_total!" do
    before(:each) do
      product1 = FactoryGirl.create :product, price: 100, quantity: 10
      product2 = FactoryGirl.create :product, price: 80, quantity: 15

      placement1 = FactoryGirl.build :placement, product: product1, quantity: 2
      placement2 = FactoryGirl.build :placement, product: product2, quantity: 2

      @order = FactoryGirl.build :order

      @order.placements << placement1
      @order.placements << placement2
    end

    it "returns the total amount to pay for the products" do
      expect{ @order.set_total! }.to change{ @order.total }.from(0).to(360)
    end

    describe ".build_placements_with_product_ids_and_quantities" do
      before(:each) do
        product1 = FactoryGirl.create :product, price: 100, quantity: 5
        product2 = FactoryGirl.create :product, price: 85, quantity: 10
        @product_ids_and_quantities = [[product1.id, 2], [product2.id, 3]]
      end

      it "builds 2 placements for the order" do
        expect{ order.build_placements_with_product_ids_and_quantities(@product_ids_and_quantities) }.to change{ order.placements.size }.from(0).to(2)
      end
    end
  end

  describe ".valid?" do
      before do
        user = FactoryGirl.create :user
        product1 = FactoryGirl.create :product, price: 100, quantity: 5
        product2 = FactoryGirl.create :product, price: 85, quantity: 10

        @order = FactoryGirl.create :order, user: user

        placement1 = FactoryGirl.create :placement, product: product1, quantity: 3, order: @order
        placement2 = FactoryGirl.create :placement, product: product2, quantity: 2, order: @order

        @order.placements << placement1
        @order.placements << placement2
      end

      it "becomes invalid due to insufficient number of products on the stock" do
        expect(@order).to_not be_valid
      end
    end

end







