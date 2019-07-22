class AddRdVToCompounds < ActiveRecord::Migration[5.2]
  def change
    add_column :compounds, :rdv_mg, :integer
  end
end
