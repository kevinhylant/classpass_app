class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.boolean    :spin
      t.boolean    :strength_training
      t.boolean    :barre
      t.boolean    :yoga
      t.boolean    :dance
      t.boolean    :pilates

      t.integer    :klass_id
    
      t.timestamps null: false
    end
  end
end
