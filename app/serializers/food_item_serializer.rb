class FoodItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :food_data_id

  has_many :compounds
end
