require 'pry'

class AllData
  attr_accessor :activity_types,:class_ratings,:klasses,:favorite_studios,:instructors,:preferences,:reservations,:scheduled_classes,:studios,:users

  def initialize(params)
    params.each do |k,v|
      self.send("#{k}=",v)
    end
    return self
  end

  def self.generate_data_dump_params
    models = {'activity_types' => ActivityType,
              'class_ratings'=> ClassRating,
              'klasses'=> Klass,
              'favorite_studios'=> FavoriteStudio,
              'instructors'=> Instructor,
              'preferences'=> Preference,
              'reservations'=> Reservation,
              'scheduled_classes'=> ScheduledClass,
              'studios'=> Studio,
              'users' => User}
    params = {}
    models.each do |model,class_name|
      params[model] = class_name.all
    end
    return params
  end


end