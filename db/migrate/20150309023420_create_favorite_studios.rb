class CreateFavoriteStudios < ActiveRecord::Migration
  def change
    create_table :favorite_studios do |t|
      
      t.integer   :user_id
      t.integer   :studio_id
      
      t.timestamps null: false
    end
  end
end
