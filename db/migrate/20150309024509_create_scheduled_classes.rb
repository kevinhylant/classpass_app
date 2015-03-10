class CreateScheduledClasses < ActiveRecord::Migration
  def change
    create_table :scheduled_classes do |t|
      t.datetime :start_time

      t.integer   :instructor_id
      t.integer   :clss_id
      
      t.timestamps null: false
    end
  end
end
