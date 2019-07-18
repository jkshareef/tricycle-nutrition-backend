class CreateFoodItemCompounds < ActiveRecord::Migration[5.2]
  def change
    create_table :food_item_compounds do |t|
      t.integer :food_item_id
      t.integer :compound_id

      t.timestamps
    end
  end
end
