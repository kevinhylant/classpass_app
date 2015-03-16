class ActivityType < ActiveRecord::Base
 belongs_to   :klass

 def return_activity_type
  activities_hash = self.attributes.select do |attribute,value|
    MyFactory.activities.include?(attribute) && value==true
  end
  return activities_hash.keys[0]
 end

end