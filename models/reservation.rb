class Reservation < ActiveRecord::Base
  belongs_to :scheduled_class
  belongs_to :user
  has_one    :clss, :through => :scheduled_class
end