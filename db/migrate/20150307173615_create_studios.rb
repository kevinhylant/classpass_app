class CreateStudios < ActiveRecord::Migration
  def change
    create_table :studios do |t|
      t.string  :name
      t.text    :description
      t.string  :neighborhood
      t.string  :zipcode

      t.timestamps null: false
    end
  end
end
