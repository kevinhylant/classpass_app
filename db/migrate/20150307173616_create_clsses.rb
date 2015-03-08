class CreateClsses < ActiveRecord::Migration
  def change
    create_table :clsses do |t|
      t.string    :name
      t.string    :activity_type
      
      t.integer   :studio_id
      t.integer   :instructor_id
    
      t.timestamps null: false
    end
  end
end
