class UserSerializer < ActiveModel::Serializer
  attributes :id, :code, :phone, :created_at, :updated_at
end
