class RenameColumnFoodDataIdToNutrientIdInCompounds < ActiveRecord::Migration[5.2]
  def change
    rename_column :compounds, :food_data_id, :nutrient_id
  end
end
