class User < ActiveRecord::Base
  has_many  :reservations #, :dependent => :destroy
  has_many  :clsses, :through => :reservations
  has_many  :favorite_studios #, :dependent => :destroy
  has_many  :class_ratings
  has_one   :preference

  def self.generate_user_params
    user_params = {}
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.free_email("#{first_name}.#{last_name}")
    user_params = {
      :first_name => first_name,
      :last_name => last_name,
      :email => email,
      :home_zipcode => MyFactory.generate_random_nyc_zipcode,
      :work_zipcode => MyFactory.generate_random_nyc_zipcode}
    return user_params
  end

end