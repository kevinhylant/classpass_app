class ClassRating < ActiveRecord::Base
  belongs_to  :scheduled_class
  belongs_to  :user

  def self.generate_params
    metrics = ['star_rating','intructor_energy','sweat_level','upbeat_music','soreness']
    params = {}
    metrics.each {|metric| params[metric] = rand(3)+3} # 3-5 star rating
    scheduled_classes = ScheduledClass.all
    scheduled_class_id = scheduled_classes[rand(scheduled_classes.size)].id
    params[:scheduled_class_id] = scheduled_class_id
    return params
  end

end