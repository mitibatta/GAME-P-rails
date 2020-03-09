class CreatePictures < ActiveRecord::Migration[6.0]
  def change
    create_table :pictures do |t|
      t.string :image
      t.string :video
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end
