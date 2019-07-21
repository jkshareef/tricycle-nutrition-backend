class FoodItem < ApplicationRecord
    has_many :meal_food_items
    has_many :meals, through: :meal_food_items
    has_many :food_item_compounds
    has_many :compounds, through: :food_item_compounds
end
