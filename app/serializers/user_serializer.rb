class UserSerializer < ActiveModel::Serializer
	embed :ids
	
	attributes :id, :email, :created_at, :updated_at, :auth_token
	
	# Solution for circular association
	# link: http://adamniedzielski.github.io/blog/2014/03/02/json-api-with-rails-api-and-active-model-serializers/
	has_many :products#, serializer: UserProductsSerializer
end
