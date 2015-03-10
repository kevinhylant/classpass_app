class Studio < ActiveRecord::Base
  has_many :clsses #, :dependent => :destroy
  has_many :instructors, :through => :clsses
  has_many :scheduled_classes, :through => :classes
  has_many :reservations, :through => :scheduled_classes
  has_many :ratings, :through => :scheduled_classes, :class_name => 'ClassRating'
  has_many :users, :through => :reservations
  has_many :times_favorited, :through => :users, :class_name => 'FavoriteStudio'
  has_many :favorite_studios
end

