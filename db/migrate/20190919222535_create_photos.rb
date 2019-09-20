class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.string :base64
      t.string :uri
      t.integer :height
      t.integer :width

      t.timestamps
    end
  end
end
