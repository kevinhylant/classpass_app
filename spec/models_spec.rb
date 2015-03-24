require 'spec_helper'

describe "Models" do
  describe "Create Associated Objects" do 

    data = MyFactory.new(3, 1, 30)  # studios count, weekly user reservations, past days count
    
      let(:studio_count)           {data.studio_count}
      let(:classes_per_studio)     {data.classes_per_studio}
      let(:instructor_count)       {data.instructor_count}
      let(:klass_count)            {data.klass_count}
      let(:user_count)             {data.user_count}
      let(:scheduled_class_count)  {data.scheduled_class_count}
      let(:activities)             {data.activities}
      let(:class_ratings_count)    {data.class_ratings_count}
      let(:favorites_count)        {data.favorites_count}
      let(:reservation_count)      {data.reservation_count}


    describe "Studios" do
      studios = Studio.all
      it 'the correct number are persisted' do
        expect(studios.count).to eq(studio_count)
      end
      it 'has a name, description, neighborhood, and zipcode' do
        expect(studios[rand(studio_count)].name).to_not eq(nil)
        expect(studios[rand(studio_count)].description).to_not eq(nil)
        expect(studios[rand(studio_count)].neighborhood).to_not eq(nil)
        expect(studios[rand(studio_count)].zipcode).to_not eq(nil)
      end
    end

    describe "Instructors" do
      it 'the correct number are persisted' do
        expect(Instructor.count).to eq(instructor_count)
      end
    end

    describe "Klasses" do
      klasses = Klass.all
      it 'the correct number are persisted' do
        expect(klasses.count).to eq(klass_count)
      end
      it 'is associated with a studio' do
        expect(klasses[rand(klass_count)].studio_id).to_not eq(nil)
        expect(klasses[rand(klass_count)].studio_id).to_not eq(nil)
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
        expect(scheduled_classes.sample(1)[0].instructor_id).to_not eq(nil)
        expect(scheduled_classes.sample(1)[0].instructor_id).to_not eq(nil)
      end
      it 'is properly associated with an klass' do 
        expect(scheduled_classes.sample(1)[0].klass_id).to_not eq(nil)
      end
      it 'is properly associated with an studio' do 
        expect(scheduled_classes.sample(1)[0].klass.studio).to_not eq(nil)
      end
      it 'is assigned a start_time' do
        expect(scheduled_classes.sample(1)[0].start_time).to_not eq(nil)
      end
      it 'is assigned a start_time after after 5am and before 10am' do
        expect(scheduled_classes.sample(1)[0].start_time.hour).to be >= 5
        expect(scheduled_classes.sample(1)[0].start_time.hour).to be <= 22
      end
    end

    describe "Activity Type" do
      activity_types = ActivityType.all
      it 'the correct number are persisted (one per scheduled class)' do
        expect(activity_types.count).to eq(klass_count)
      end
      it 'is properly associated with a klass' do 
        expect(activity_types.count).to eq(klass_count)
        expect(activity_types[rand(klass_count)].klass_id).to_not eq(nil)
      end
      it 'has at least one true value' do
        random_1 = activity_types[rand(klass_count)]
        random_2 = activity_types[rand(klass_count)]
        boolean_values_1,boolean_values_2 = [],[]
        MyFactory.activities.each do |type| 
          boolean_values_1 << random_1.send(type) 
          boolean_values_2 << random_2.send(type) 
        end
        expect(boolean_values_1).to include(true)
        expect(boolean_values_2).to include(true)
      end
    end

    describe "Users" do
      users = User.all
      random_1 = users.sample(1)[0];
      random_2 = users.sample(1)[0];

      it 'the correct number are persisted' do
        expect(users.count).to eq(user_count)
      end
      it 'have first and last names, zipcodes, and emails' do
        random_users = [random_1,random_2]
        user_attributes = ['first_name','last_name','email','home_zipcode','work_zipcode']

        random_users.each do |rando|
          user_attributes.each do |attribute|
            expect(rando.send(attribute)).to be_truthy
          end
        end
      end
      it 'can have associated favorite_studios' do
        expect(random_1.favorite_studios).to_not eq(nil)
      end
      it 'can have no more than 3 reservations per studio' do
        reservations = random_1.reservations
        reservations_per_studio = {}
        reservations.each do |res|
          reservations_per_studio[res.studio.name] ||= 0
          reservations_per_studio[res.studio.name] += 1
        end
        expect(reservations_per_studio.values.max).to be <= 3
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

    describe 'Reservations' do
      reservations = Reservation.all
      it 'The correct number are persisted ' do
        expect(reservations.size).to eq(reservation_count)
      end
      it 'Reservations are associated with users' do
        expect(reservations[rand(reservation_count)].user_id).to_not eq(nil)
      end
      it 'Reservations are associated with scheduled classes' do
        expect(reservations[rand(reservation_count)].scheduled_class_id).to_not eq(nil)
      end
      it 'Reservations are associated with klasses' do
        expect(reservations[rand(reservation_count)].klass).to_not eq(nil)
      end

    end



  end
end

