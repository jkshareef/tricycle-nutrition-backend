class AddDateAsDatetimeToMeals < ActiveRecord::Migration[5.2]
  def change
    add_column :meals, :date, :datetime
  end
end
