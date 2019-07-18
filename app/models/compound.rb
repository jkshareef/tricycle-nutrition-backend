class Compound < ApplicationRecord
    has_many :food_item_compounds
    has_many :food_items, through: :food_item_compounds
end
