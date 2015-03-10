class CreateScheduledClasses < ActiveRecord::Migration
  def change
    create_table :scheduled_classes do |t|

      t.integer   :instructor_id
      t.integer   :clss_id
      
      t.timestamps null: false
    end
  end
end
