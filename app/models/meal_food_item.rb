class MealFoodItem < ApplicationRecord
    belongs_to :meal
    belongs_to :food_item
end
