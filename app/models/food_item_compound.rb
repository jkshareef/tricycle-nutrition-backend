class FoodItemCompound < ApplicationRecord
    belongs_to :food_item
    belongs_to :compounds
end
