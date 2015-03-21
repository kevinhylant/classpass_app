class ScheduledClass < ActiveRecord::Base
  has_many    :ratings, :class_name => "ClassRating" , :dependent => :destroy
  has_many    :reservations , :dependent => :destroy
  has_many    :users, :through => :reservations
  belongs_to  :klass
  belongs_to  :instructor
  has_one     :activity_type, :through => :klass
  has_one     :studio, :through => :klass

  def self.generate_params(past_days,future_days)
    time_of_class = ScheduledClass.generate_random_class_time(past_days,future_days)
    params = {}
    params[:start_time] = time_of_class
    params[:instructor_id] = Instructor.all.sample(1)[0].id
    return params
  end

  def self.generate_random_class_time(past_days,future_days)
    class_days  = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']
    min_options = [0,15,30,45]
    earliest    = 5
    latest      = 22
    hour        = rand(latest-earliest)+earliest
    minute      = min_options[rand(4)]
    weekday     = class_days[rand(class_days.size)]
    span_of_days= (past_days+future_days)    
    
    rand_day_in_span = rand(span_of_days)
    
    if rand_day_in_span > past_days
      tense = 'days from now' 
    elsif rand_day_in_span < past_days
      tense = 'days ago'
    elsif rand_day_in_span == past_days
      tense = 'today'
    end
    
    if tense == 'today'
      time_of_class = Chronic.parse("#{tense} at #{hour}:#{minute}")
    else
      time_of_class = Chronic.parse("#{hour} #{tense} #{weekday} at #{hour}:#{minute}")
    end    
    return time_of_class
  end

  def return_self_and_associated_objects
    class_hash = JSON.parse(self.to_json)   
    class_hash["scheduled_class"]['klass'] = JSON.parse(self.klass.to_json)['klass']
    class_hash["scheduled_class"]['studio'] = JSON.parse(self.studio.to_json)['studio']
    class_hash["scheduled_class"]['activity_type'] = JSON.parse(self.activity_type.to_json)['activity_type']
    return class_hash["scheduled_class"]
  end

end

