class RemoveUriFromPhotos < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :uri, :string
  end
end
