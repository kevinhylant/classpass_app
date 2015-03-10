class ClassRating < ActiveRecord::Base
  belongs_to  :scheduled_class
  belongs_to  :user

  def assign_user(user)
    self.user_id = user.id
    self.save
  end

end