class CreateCompounds < ActiveRecord::Migration[5.2]
  def change
    create_table :compounds do |t|
      t.string :name
      t.integer :food_data_id
      t.string :description

      t.timestamps
    end
  end
end
