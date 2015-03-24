class Studio < ActiveRecord::Base
  has_many :favorite_studios
  has_many :klasses ,         :dependent => :destroy
  has_many :instructors,      :through => :klasses
  has_many :scheduled_classes,:through => :klasses
  has_many :reservations,     :through => :scheduled_classes
  has_many :ratings,          :through => :scheduled_classes, :class_name => 'ClassRating'
  has_many :users,            :through => :reservations
  has_many :times_favorited,  :through => :users, :class_name => 'FavoriteStudio'


  def self.generate_params
    zip_and_neighborhood = MyFactory.generate_random_nyc_zipcode_and_neighborhood
    params = {
      :name => "#{Faker::Name.first_name}'s Studio",
      :description => Faker::Company.catch_phrase,
      :zipcode => zip_and_neighborhood[0],
      :neighborhood => zip_and_neighborhood[1]}
    return params    
  end

  def return_self_and_associated_objects
    studio_hash = {}
    studio_hash = JSON.parse(self.to_json)['studio']

    klasses = self.klasses
    studio_hash['klasses'] = klasses.collect do |klass|
      
      klass_hash = {}
      klass_hash = JSON.parse(klass.to_json)['klass']
  
      scheduled_classes = klass.scheduled_classes
      klass_hash['scheduled_classes'] = scheduled_classes.collect do |sc|
        sc_hash = {}
        sc_hash = JSON.parse(sc.to_json)['scheduled_class']

        class_ratings = sc.ratings
        sc_hash['ratings'] = class_ratings.collect do |rating|
          JSON.parse(rating.to_json)['class_rating']
        end
        sc_hash
      end

      activity_type = klass.activity_type
      klass_hash['activity_type'] = JSON.parse(activity_type.to_json)['activity_type']
      
      klass_hash
    end
    
    return studio_hash
  end

end

