class User < ActiveRecord::Base
  has_many  :reservations , :dependent => :destroy
  has_many  :klasses, :through => :reservations
  has_many  :favorite_studios , :dependent => :destroy
  has_many  :scheduled_classes, :through => :reservations
  has_many  :klasses, :through => :scheduled_classes
  has_many  :activity_types, :through => :klasses
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

  def past_activities_breakdown(num_of_days=30)
    today = DateTime.now
    timeframe = num_of_days.days
    breakdown = {}
    breakdown['total'] = 0
    self.reservations.each do |res|
      class_time = res.scheduled_class.start_time
      if class_time <= today && class_time >= (today - timeframe)
        activity = res.activity_type.return_activity_type
        breakdown[activity] ||= 0
        breakdown[activity] += 1
        breakdown['total'] += 1
      end
    end

    return breakdown
  end

  def past_activities_breakdown_by_number(num_of_days=30)
    return past_activities_breakdown(num_of_days)
  end

  def past_activities_breakdown_by_ratio(num_of_days=30)
    breakdown_by_num = past_activities_breakdown(num_of_days)
    past_classes_count = breakdown_by_num['total']
    percentage_breakdown = {}

    breakdown_by_num.each do |activity,num|
      percentage_breakdown[activity] = ((num.to_f/past_classes_count)*100).round(2) if activity != 'total'
    end
    return percentage_breakdown
  end

  def return_classes(state)
    classes = self.scheduled_classes.select do |sc| 
      state == 'upcoming' ? sc.start_time > Time.now : sc.start_time < Time.now
    end
    classes.sort! { |a,b| a.start_time <=> b.start_time}
    return classes
  end

  def return_self_and_preferences
    user_hash = {}
    user_hash = JSON.parse(self.to_json)['user']
    preference = self.preference
    user_hash['preferences'] = JSON.parse(preference.to_json)['preference']
    return user_hash
  end

end






