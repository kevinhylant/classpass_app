require 'spec_helper'

describe "Models" do
  describe "Create Associated Objects" do 

    # configure MyFactory
    studio_count = 3
    classes_per_studio = 2
    num_scheduled_per_clss = 2
    instructor_count = 10
    user_count = 30
    scheduled_class_count = studio_count*classes_per_studio*num_scheduled_per_clss
    class_ratings_count = 2*scheduled_class_count
    favorites_count = user_count*2
    activities = ['spin','strength_training','barre','yoga','dance','pilates']
      let(:studio_count) {studio_count}
      let(:classes_per_studio) {classes_per_studio}
      let(:num_scheduled_per_clss) {num_scheduled_per_clss}
      let(:instructor_count) {instructor_count}
      let(:clss_count) {studio_count*classes_per_studio}
      let(:user_count) {user_count}
      let(:scheduled_class_count) {scheduled_class_count}
      let(:activities) {activities}
      let(:class_rating_count) {class_rating_count}
      let(:favorites_count) {favorites_count}

    studios = MyFactory.create_and_return_studios(studio_count)
    instructors = MyFactory.create_and_return_instructors(instructor_count)
    clsses = MyFactory.create_and_return_clsses(studios,classes_per_studio)
    scheduled_classes = MyFactory.create_and_return_scheduled_classes(clsses,instructors,num_scheduled_per_clss)
    users = MyFactory.create_and_return_users(user_count)
    activity_types = MyFactory.assign_and_return_activity_types(clsses,activities)
    MyFactory.assign_class_ratings(scheduled_classes, users, class_ratings_count)
    MyFactory.assign_favorite_studios(studios,users,favorites_count)
    MyFactory.assign_user_preferences(users)


    describe "Studios" do
      it 'the correct number are persisted' do
        expect(Studio.count).to eq(studio_count)
      end
    end

    describe "Instructors" do
      it 'the correct number are persisted' do
        expect(Instructor.count).to eq(instructor_count)
      end
    end

    describe "Clsses" do
      it 'the correct number are persisted' do
        expect(Clss.count).to eq(clss_count)
      end
      it 'is associated with a studio' do
        expect(Clss.all[rand(clss_count)].studio_id).to_not eq(nil)
        expect(Clss.all[rand(clss_count)].studio_id).to_not eq(nil)
      end
      it 'has at least one activity type' do

      end
    end

    describe "Scheduled Classes" do
      scheduled_classes = ScheduledClass.all

      it 'the correct number are persisted' do
        expect(scheduled_classes.count).to eq(scheduled_class_count)
      end
      it 'is associated with an instructor' do
        expect(scheduled_classes[rand(scheduled_class_count)].instructor_id).to_not eq(nil)
        expect(scheduled_classes[rand(scheduled_class_count)].instructor_id).to_not eq(nil)
      end
      it 'is properly associated with an clss' do 
        expect(scheduled_classes[rand(scheduled_class_count)].clss_id).to_not eq(nil)
      end
      it 'is properly associated with an studio' do 
        expect(scheduled_classes[rand(scheduled_class_count)].clss.studio).to_not eq(nil)
      end
      it 'is assigned a start_time' do
        expect(scheduled_classes[rand(scheduled_class_count)].start_time).to_not eq(nil)
      end
      it 'is assigned a start_time after after 6am and before 10am' do
        expect(scheduled_classes[rand(scheduled_class_count)].start_time.hour).to be >= 6
        expect(scheduled_classes[rand(scheduled_class_count)].start_time.hour).to be <= 22
      end
    end

    describe "Activity Type" do
      activity_types = ActivityType.all
      it 'the correct number are persisted (one per scheduled class)' do
        expect(activity_types.count).to eq(clss_count)
      end
      it 'has at least one true value' do
        random_1 = activity_types[rand(clss_count)]
        random_2 = activity_types[rand(clss_count)]
        boolean_values_1,boolean_values_2 = [],[]
        activities.each do |type| 
          boolean_values_1 << random_1.send(type) 
          boolean_values_2 << random_2.send(type) 
        end
        expect(boolean_values_1).to include(true)
        expect(boolean_values_2).to include(true)
      end
    end

    describe "Users" do
      users = User.all
      it 'the correct number are persisted' do
        expect(users.count).to eq(user_count)
      end
      it 'have first and last names, zipcodes, and emails' do
        random_1 = users[rand(user_count)]
        random_2 = users[rand(user_count)]
        random_users = [random_1,random_2]
        user_attributes = ['first_name','last_name','email','home_zipcode','work_zipcode']

        random_users.each do |rando|
          user_attributes.each do |attribute|
            expect(rando.send(attribute)).to be_truthy
          end
        end
      end
      it 'can have associated favorite_studios' do

      end
    end

    describe "Class Rating" do
      it 'The correct number are persisted' do
        expect(ClassRating.count).to eq(class_ratings_count)
      end
    end

    describe 'Favorite Studio' do 
      favorite_studios = FavoriteStudio.all

      it 'The correct number are persisted ' do
        expect(favorite_studios.size).to eq(favorites_count)
      end
      it 'Favorite studios are associated with users' do
        expect(favorite_studios[rand(favorites_count)].user_id).to_not eq(nil)
      end
      it 'Favorite studios are associated with studios' do
        expect(favorite_studios[rand(favorites_count)].studio_id).to_not eq(nil)
      end

    end

    describe 'Preference' do 
      preferences = Preference.all
      it 'The correct number are persisted ' do
        expect(preferences.size).to eq(user_count)
      end
      it 'Preferences are associated with users' do
        expect(preferences[rand(user_count)].user_id).to_not eq(nil)
      end
      
    end

  end
end

