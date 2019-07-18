class FoodItem < ApplicationRecord
    has_many :meals
    has_many :compounds
end
