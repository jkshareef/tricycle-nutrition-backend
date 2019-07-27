class AddUnitsColumnToCompounds < ActiveRecord::Migration[5.2]
  def change
    add_column :compounds, :units, :string
  end
end
