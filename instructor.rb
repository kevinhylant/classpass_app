class Instructor < ActiveRecord::Base
  has_many :clsses
  has_many :studios, through: :clsses
end