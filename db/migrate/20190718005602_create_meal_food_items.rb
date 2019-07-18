class CreateMealFoodItems < ActiveRecord::Migration[5.2]
  def change
    create_table :meal_food_items do |t|
      t.integer :meal_id
      t.integer :food_item_id

      t.timestamps
    end
  end
end
