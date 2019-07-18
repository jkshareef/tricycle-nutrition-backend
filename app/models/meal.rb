class Meal < ApplicationRecord
    has_many :food_items
    belongs_to :user
end
