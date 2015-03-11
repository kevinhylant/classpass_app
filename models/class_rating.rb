class ClassRating < ActiveRecord::Base
  belongs_to  :scheduled_class
  belongs_to  :user

  def assign_user(user)
    self.user_id = user.id
    self.save
  end

  def self.generate_params
    metrics = ['star_rating','intructor_energy','sweat_level','upbeat_music','soreness']
    params = {}
    metrics.each {|metric| params[metric] = rand(5)+1}
    return params
  end

end