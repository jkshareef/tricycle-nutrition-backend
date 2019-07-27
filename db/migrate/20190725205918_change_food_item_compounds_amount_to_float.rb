class ChangeFoodItemCompoundsAmountToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :food_item_compounds, :amount_mg, :float
  end
end
