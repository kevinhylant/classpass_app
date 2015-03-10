class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer    :intructor_energy
      t.integer    :sweat_level
      t.integer    :upbeat_music
      t.integer    :soreness

      t.boolean    :spin
      t.boolean    :strength_training
      t.boolean    :barre
      t.boolean    :yoga
      t.boolean    :dance
      t.boolean    :pilates

      t.boolean    :before_work    # 5a - 9a start time
      t.boolean    :during_lunch   # 12p- 1p start time
      t.boolean    :after_work     # 5p - 9p start time

      t.integer    :user_id

      t.timestamps null: false
    end
  end
end
