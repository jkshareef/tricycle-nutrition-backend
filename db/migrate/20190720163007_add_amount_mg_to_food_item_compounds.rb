class AddAmountMgToFoodItemCompounds < ActiveRecord::Migration[5.2]
  def change
    add_column :food_item_compounds, :amount_mg, :integer
  end
end
