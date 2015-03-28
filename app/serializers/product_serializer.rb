class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :published
 
  has_one :user, include: true
end
