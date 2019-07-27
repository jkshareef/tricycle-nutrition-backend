class RenameFoodItemCompoundsAmountMgToAmount < ActiveRecord::Migration[5.2]
  def change
    rename_column :food_item_compounds, :amount_mg, :amount
  end
end
