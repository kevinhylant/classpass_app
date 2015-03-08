class Studio < ActiveRecord::Base
  has_many :clsses, :dependent => :destroy
  has_many :instructors, :through => :clsses
end

