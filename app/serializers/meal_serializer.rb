class MealSerializer < ActiveModel::Serializer
  attributes :id, :date

  has_many :food_items
  has_one :user
end
