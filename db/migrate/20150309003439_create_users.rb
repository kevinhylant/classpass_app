class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :first_name
      t.string    :last_name
      t.string    :email
      t.string    :home_zipcode
      t.string    :work_zipcode
      
    
      t.timestamps null: false
    end
  end
end
