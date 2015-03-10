class MyFactory

  def self.create_and_return_instructors(num)
    num.times do
      Instructor.create(:first_name => Faker::Name.first_name,
                        :last_name => Faker::Name.last_name
        )
    end
    return Instructor.all
  end

  def self.create_and_return_studios(num)
    num.times do 
      Studio.create(:name => "#{Faker::Name.first_name}'s Studio")
    end
    return Studio.all
  end

  def self.create_and_return_clsses(studios,num_per_studio)
    studios.each do |s|
      num_per_studio.times do
        s.clsses.create(:name => "Get Your Sweat On With #{Faker::Name.first_name}")
      end
    end
    return Clss.all
  end

  def self.create_and_return_scheduled_classes(clsses,instructors,num_scheduled_per_clss)
    clsses.each do |c|
      num_scheduled_per_clss.times do
        c.scheduled_classes.create(:instructor_id => instructors[rand(instructors.count)].id)
      end
    end
    return ScheduledClass.all
  end

  def self.assign_and_return_activity_types(clsses,activities)
    clsses.each do |clss|
      activities_to_assign_count = rand(2)+1
      a1_index = rand(activities.size)    
      activities_hash = {}
      activities_hash[activities[a1_index]] = true
      if activities_to_assign_count > 1
        a2_index = (a1_index-1) 
        activities_hash[activities[a2_index]] = true
      end
      clss.create_activity_type(activities_hash)
    end
    return ActivityType.all
  end

  def self.assign_class_ratings(scheduled_classes,users,class_ratings_count)
    class_ratings_count.times do
      rating_params = MyFactory.generate_rating_params
      rating = scheduled_classes[rand(scheduled_classes.size)].ratings.create(rating_params)
      rating.assign_user(users[rand(users.size)])
    end
  end

  def self.generate_rating_params
    metrics = ['star_rating','intructor_energy','sweat_level','upbeat_music','soreness']
    rating_params = {}
    metrics.each {|metric| rating_params[metric] = rand(5)+1}
    return rating_params
  end

  def self.create_and_return_users(num)
    num.times do
      user_params = User.generate_user_params
      User.create(user_params)
    end
  end

  def self.generate_random_nyc_zipcode
    nyc_zipcodes = ['10001','10002','10003','10014','10016']
    return nyc_zipcodes[rand(nyc_zipcodes.size)]
  end
  

end