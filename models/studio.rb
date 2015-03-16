class Studio < ActiveRecord::Base
  has_many :klasses , :dependent => :destroy
  has_many :instructors, :through => :klasses
  has_many :scheduled_classes, :through => :classes
  has_many :reservations, :through => :scheduled_classes
  has_many :ratings, :through => :scheduled_classes, :class_name => 'ClassRating'
  has_many :users, :through => :reservations
  has_many :times_favorited, :through => :users, :class_name => 'FavoriteStudio'
  has_many :favorite_studios

  def self.generate_params
    zip_and_neighborhood = MyFactory.generate_random_nyc_zipcode_and_neighborhood
    params = {
      :name => "#{Faker::Name.first_name}'s Studio",
      :description => Faker::Company.catch_phrase,
      :zipcode => zip_and_neighborhood[0],
      :neighborhood => zip_and_neighborhood[1]}
    return params    
  end
end

