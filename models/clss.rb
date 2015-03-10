class Clss < ActiveRecord::Base
  has_many    :scheduled_classes #, :dependent => :destroy
  has_many    :ratings, :through => :scheduled_classes
  has_many    :reservations, :through => :scheduled_classes
  has_one     :activity_type #, :dependent => :destroy
  belongs_to  :studio
end