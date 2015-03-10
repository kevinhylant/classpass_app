class ScheduledClass < ActiveRecord::Base
  belongs_to  :clss
  belongs_to  :instructor
  has_many    :ratings, :class_name => "ClassRating", :dependent => :destroy
  has_many    :reservations #, :dependent => :destroy
  has_many    :users, :through => :reservations
end