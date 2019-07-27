class Meal < ApplicationRecord
    has_many :meal_food_items, dependent: :destroy
    has_many :food_items, through: :meal_food_items
    belongs_to :user
end
