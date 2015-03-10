class ScheduledClass < ActiveRecord::Base
  belongs_to  :clss
  belongs_to  :instructor
  has_many    :ratings, :class_name => "ClassRating" #, :dependent => :destroy
  has_many    :reservations #, :dependent => :destroy
  has_many    :users, :through => :reservations

  def self.generate_params
    instructors = Instructor.all
    instructor_id = instructors[rand(instructors.count)].id
    time_of_class = ScheduledClass.generate_random_class_time
    params = {}
    params[:instructor_id] = instructor_id
    params[:start_time] = time_of_class
    return params
  end

  def self.generate_random_class_time
    class_days = ['monday','tuesday','wednesday','thursday','friday']
    interval = 15.minutes
    earliest = 5
    latest = 22
    day_of_class = class_days[rand(class_days.size)]
    earliest_class_time = Chronic.parse("#{day_of_class} #{earliest} in the morning")
    num_of_intervals = (latest-earliest)*(60.minutes/interval)
    random_interval = rand(num_of_intervals)
    time_of_class = earliest_class_time+(random_interval*interval)
    return time_of_class
  end

end