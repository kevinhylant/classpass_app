class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|

      t.integer    :user_id
      t.integer    :scheduled_class_id
    
      t.timestamps null: false
    end
  end
end
