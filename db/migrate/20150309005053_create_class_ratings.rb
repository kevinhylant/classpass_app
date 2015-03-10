class CreateClassRatings < ActiveRecord::Migration
   def change
    create_table :class_ratings do |t|
      t.integer    :star_rating

      t.integer    :intructor_energy
      t.integer    :sweat_level
      t.integer    :upbeat_music
      t.integer    :soreness

      t.integer    :user_id
      t.integer    :scheduled_class_id

      t.timestamps null: false
    end
  end
end
