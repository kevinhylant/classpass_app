class MyFactory

  def self.seed_database(size)

    if size == 'small'
      studio_count = 3
      classes_per_studio = 2
      num_scheduled_per_clss = 2
      instructor_count = 10
      user_count = 30
      scheduled_class_count = studio_count*classes_per_studio*num_scheduled_per_clss
      class_ratings_count = 2*scheduled_class_count
      favorites_count = user_count*2
    elsif size == 'medium'
      studio_count = 40
      classes_per_studio = 3
      num_scheduled_per_clss = 8
      instructor_count = 60
      user_count = 150
      scheduled_class_count = studio_count*classes_per_studio*num_scheduled_per_clss
      class_ratings_count = 2*scheduled_class_count
      favorites_count = user_count*2
    end
    activities = ['spin','strength_training','barre','yoga','dance','pilates']

    studios = MyFactory.create_and_return_studios(studio_count)
    instructors = MyFactory.create_and_return_instructors(instructor_count)
    clsses = MyFactory.create_and_return_clsses(studios,classes_per_studio)
    scheduled_classes = MyFactory.create_and_return_scheduled_classes(clsses,instructors,num_scheduled_per_clss)
    users = MyFactory.create_and_return_users(user_count)
    activity_types = MyFactory.assign_and_return_activity_types(clsses,activities)
    MyFactory.assign_class_ratings(scheduled_classes, users, class_ratings_count)
    MyFactory.assign_favorite_studios(studios,users,favorites_count)
    MyFactory.assign_user_preferences(users)

  end

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
        params = ScheduledClass.generate_params
        c.scheduled_classes.create(params)
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
      rating_params = ClassRating.generate_params
      rating = scheduled_classes[rand(scheduled_classes.size)].ratings.create(rating_params)
      rating.assign_user(users[rand(users.count)])
    end
  end


  def self.create_and_return_users(num)
    num.times do
      user_params = User.generate_user_params
      User.create(user_params)
    end
    return User.all
  end

  def self.generate_random_nyc_zipcode
    nyc_zipcodes = ['10001','10002','10003','10014','10016']
    return nyc_zipcodes[rand(nyc_zipcodes.size)]
  end
  
  def self.assign_favorite_studios(studios, users, num)
    num.times do
      users[rand(users.size)].favorite_studios.create(:studio_id => studios[rand(studios.size)].id)
    end
  end

  def self.assign_user_preferences(users)
    users.each do |u|
      params = Preference.generate_params
      u.create_preference(params)
    end
  end

end