class ChangeRdvToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :compounds, :rdv_mg, :float
  end
end
