class Order < ActiveRecord::Base
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true

  before_validation :set_total!

  def set_total!
    sum = 0
    if self.products.count > 0
      self.products.each { |product| 
        sum += product.price
      }
    end
    self.total = sum
  end

end
