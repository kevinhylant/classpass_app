class Reservation < ActiveRecord::Base
  belongs_to :scheduled_class
  belongs_to :user
  has_one    :klass, :through => :scheduled_class
  has_one    :activity_type, :through => :klass
  has_one    :studio, :through => :klass

  def self.generate_params
    scheduled_classes = ScheduledClass.all
    scheduled_class = scheduled_classes[rand(scheduled_classes.size)]
    klass = scheduled_class.klass
    scheduled_class_id = scheduled_class.id
    params = {
      :scheduled_class_id => scheduled_class_id
    }
    return params
  end

end