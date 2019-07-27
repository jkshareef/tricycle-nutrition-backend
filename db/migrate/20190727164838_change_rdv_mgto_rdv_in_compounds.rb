class ChangeRdvMgtoRdvInCompounds < ActiveRecord::Migration[5.2]
  def change
    rename_column :compounds, :rdv_mg, :rdv
  end
end
