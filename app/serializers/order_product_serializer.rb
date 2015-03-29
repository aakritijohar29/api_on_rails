class OrderProductSerializer < ActiveModel::Serializer

  attributes :id, :title, :price, :created_at

  def include_user?
    false
  end
end
