require 'rails_helper'

RSpec.describe Placement, type: :model do
  
  before do
    product = FactoryGirl.create :product, price: 100, quantity: 30
    @placement = FactoryGirl.create :placement, product: product
  end
  #let (:placement) { FactoryGirl.build :placement }

  it { should respond_to :order_id }
  it { should respond_to :product_id }
  it { should respond_to :quantity }

  it { should belong_to :order }
  it { should belong_to :product }

  describe "#decrement_product_quantity!" do
    it "decreases the product quantity by the placement quantity" do
      product = @placement.product
      expect{ @placement.decrement_product_quantity! }.to change{ product.quantity }.by(-@placement.quantity)
    end
  end

end
