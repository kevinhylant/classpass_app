class Preference < ActiveRecord::Base
  belongs_to  :user

  def self.generate_params
    params = {}
    params = Preference.generate_time_preferences_and_add(params)
    params = Preference.generate_metric_preferences_and_add(params)
    params = Preference.generate_activity_preferences_and_add(params)
    return params
  end

  def self.generate_time_preferences_and_add(params)
    possible_times = ['before_work','during_lunch','after_work']
    preferences_count = rand(possible_times.size)+1
    time_preferences = []
    if preferences_count == 1
      time_preferences << possible_times[rand(possible_times.size)]
    elsif preferences_count == 2
      first_index = rand(possible_times.size)
      time_preferences << possible_times[first_index]
      time_preferences << possible_times[first_index-1]
    else
      time_preferences = possible_times
    end
    time_preferences.each do |time|
      params[time] = true
    end
    return params
  end

  def self.generate_metric_preferences_and_add(params)
    metrics = ['intructor_energy','sweat_level','upbeat_music','soreness']
    metrics.each do |m|
      params[m] = rand(5)+1
    end
    return params
  end

  def self.generate_activity_preferences_and_add(params)
    activities = ['spin','strength_training','barre','yoga','dance','pilates']
    activities.each do |a|
      params[a] = [true,false][rand(2)]
    end
    return params
  end

end