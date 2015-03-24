class MyFactory
  attr_reader :studio_count,:days_open_per_week, :past_days,:future_days,:days_of_data,    :klasses_per_studio,:daily_scheduled_per_klass,:user_count,:avg_favorites_per_user,:cp_users_per_studio,:cp_users_per_scheduled_class,:daily_scheduled_classes_per_instructor,:ratio_of_rated_classes,   :daily_scheduled_classes,:avg_daily_reservations_per_user,:avg_reservations_per_user,:scheduled_class_count,:instructor_count,:reservation_count,:class_ratings_count,:favorites_count,   :klass_count,:studios,:instructors,:klasses,:scheduled_classes,:users,:activity_types,:reservations

  def self.activities 
    activities = ['spin','strength_training','barre','yoga','dance','pilates']
    return activities
  end

  def initialize(studio_count,weekly_reservations_per_user, past_days)
    # database generation scales relative to # of studios, reservations per user per week, & historical operating time
    @studio_count  = studio_count
    @past_days     = past_days
    @future_days   = 7

    @days_of_data  = (past_days+future_days)
    
    @klasses_per_studio        = 2
    @avg_favorites_per_user    = 3
    @daily_scheduled_per_klass = 2

    @cp_users_per_studio                    = 20
    @ratio_of_rated_classes                 = 0.5
    @daily_scheduled_classes_per_instructor = 4

    @avg_daily_reservations_per_user = (weekly_reservations_per_user/7.0)

    @avg_reservations_per_user = (avg_daily_reservations_per_user*days_of_data)
    @user_count  =            (cp_users_per_studio*studio_count)
    @reservation_count =      (avg_reservations_per_user*user_count).to_i
    @scheduled_class_count =  (reservation_count)
    @klass_count =            (studio_count*klasses_per_studio)
    @daily_scheduled_classes= (scheduled_class_count/days_of_data)
    @instructor_count =       (daily_scheduled_classes/daily_scheduled_classes_per_instructor)
    @class_ratings_count =    (reservation_count*ratio_of_rated_classes).to_i
    @favorites_count =        (user_count*avg_favorites_per_user)

    self.seed_database
  end

  def self.generate_random_nyc_zipcode
    nyc_zipcodes = ['10001','10002','10003','10014','10016']
    return nyc_zipcodes[rand(nyc_zipcodes.size)]
  end

  def self.generate_random_nyc_zipcode_and_neighborhood
    zips = ['10001','10002','10003','10014','10016']
    nyc_zips_and_neighborhoods = {zips[0] => 'Midtown',
                                  zips[1] => 'LES',
                                  zips[2] => 'NoHo',
                                  zips[3] => 'West Village',
                                  zips[4] => 'Murray Hill'}
    rand_zip = zips[rand(zips.size)]
    output = [rand_zip, nyc_zips_and_neighborhoods[rand_zip]]
    return output
  end



  def seed_database
    @studios = create_and_return_studios
    @klasses = create_and_return_klasses
    @instructors = create_and_return_instructors
    @scheduled_classes = create_and_return_scheduled_classes
    @users = create_and_return_users
    @activity_types = create_and_return_activity_types
    @reservations = create_and_return_reservations
    assign_class_ratings
    assign_favorite_studios
    assign_user_preferences
  end


  def create_and_return_studios
    studio_count.times do 
      params = Studio.generate_params 
      Studio.create(params)
    end    
    return Studio.all
  end

  def create_and_return_klasses
    studios.each do |s|
      klasses_per_studio.times do
        s.klasses.create(:name => "Get Your Sweat On With #{Faker::Name.first_name}")
      end
    end
    return Klass.all
  end

  def create_and_return_scheduled_classes
    scheduled_class_count.times do
      klass = klasses[rand(klasses.size)]      
      params = ScheduledClass.generate_params(past_days,future_days)
      klass.scheduled_classes.create(params)
    end
    return ScheduledClass.all
  end
 
  def create_and_return_instructors
    instructor_count.times do
      Instructor.create(:first_name => Faker::Name.first_name,
                        :last_name => Faker::Name.last_name)
    end
    return Instructor.all
  end
   
  def create_and_return_activity_types
    klasses.each do |klass|
      activities = MyFactory.activities
      activity_index = rand(activities.size) 
      activities_params = {}
      activities_params[activities[activity_index]] = true
      klass.create_activity_type(activities_params)
    end
    return ActivityType.all
  end

  def create_and_return_users
    user_count.times do
      user_params = User.generate_user_params
      User.create(user_params)
    end
    return User.all
  end

  def create_and_return_reservations
    reservation_count.times do
      params = Reservation.generate_params
      associated_scheduled_class = ScheduledClass.find(params[:scheduled_class_id])
      user = pick_compatible_user(associated_scheduled_class)
      user.reservations.create(params)
    end
    return Reservation.all
  end

  def pick_compatible_user(associated_scheduled_class)
    studio_name = associated_scheduled_class.studio.name
    i = 1
    while (i != 0)    
      user = User.all.sample(1)[0]
      reservations = user.reservations
      reservations_per_studio = {}
      reservations.each do |res|
        reservations_per_studio[res.studio.name] ||= 0
        reservations_per_studio[res.studio.name] += 1
      end
      if reservations_per_studio[studio_name] == nil || reservations_per_studio[studio_name] < 3
        i = 0 
      else
        i += 1
      end

      first_reservation ||= Reservation.first if Reservation.first
      puts "PRINTING RESERVATION WITH ID #{Reservation.last.id}" if first_reservation
      puts "PRINTING #{i} TIMES"
      binding.pry if i >= users.count
    end
    return user
  end
  

  def assign_class_ratings
    class_ratings_count.times do
      rating_params = ClassRating.generate_params
      users[rand(users.size)].class_ratings.create(rating_params)
    end
    
  end

  def assign_favorite_studios
    favorites_count.times do
      users[rand(users.size)].favorite_studios.create(:studio_id => studios[rand(studio_count)].id)
    end
  end

  def assign_user_preferences
    users.each do |u|
      params = Preference.generate_params
      u.create_preference(params)
    end
  end




end