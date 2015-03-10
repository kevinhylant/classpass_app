class Instructor < ActiveRecord::Base
  has_many :scheduled_classes
  has_many :clsses, :through => :scheduled_classes
  has_many :studios, :through => :clsses
  has_many :ratings, :through => :scheduled_classes, :class_name => "ClassRating"
end