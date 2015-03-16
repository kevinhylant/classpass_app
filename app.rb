require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'

require 'json'
require 'rubygems'

require 'factory_girl'
require 'database_cleaner'
require 'faker'
require './environment.rb'

Dir["./models/*.rb"].each {|file| require file }
# Dir["./spec/factories/*.rb"].each {|file| require file }

db_options = {adapter: 'sqlite3', database: './db/cp_dev_db'}
ActiveRecord::Base.establish_connection(db_options)

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::Flash
  enable :sessions

  get "/" do
    @studio_attributes = ['name','description','neighborhood','zipcode']
    @class_attributes  = ['name']
    @instructor_attrs  = ['name']
    @user_attributes   = ['first_name','last_name','email','home_zipcode','work_zipcode']
    @activity_types    = ['spin','strength_training','barre','yoga','dance',]
    @preferences       = ['intructor_energy','sweat_level','upbeat_music','soreness','spin','strength_training','barre','yoga','dance','pilates','before_work','during_lunch','after_work','pilates']
    @instructor_ratings= ['intructor_energy','sweat_level','upbeat_music','soreness']

    erb :home
  end

  # get "/studios" do
  #   @studios = Studio.all
  #   erb :studio
  # end

  # get "/delete/elaine" do
  #   user = User.find_by_username "elaine"
  #   user.destroy
  # end

  ######## API ENDPOINTS START ########
  get '/basic_user_stats/:id' do
    content_type :json
    user = User.find(params[:id])
    scheduled_classes = user.scheduled_classes
    completed_count, upcoming_count = 0, 0
    scheduled_classes.each do |sc|
      sc.start_time < Time.now ? completed_count += 1 : upcoming_count += 1
    end
    @basic_user_stats = {:upcoming_count => upcoming_count,
                         :completed_count => completed_count}
    @basic_user_stats.to_json
        # @instructors = Instructor.all(:order => :last_name)
  end

  get '/user_activities_breakdown/:id' do 
    content_type :json
    user = User.find(params[:id])
    @user_activities = user.past_activities_breakdown_by_ratio
    @user_activities.to_json
  end

  get '/user_upcoming_classes/:id' do 
    content_type :json
    user = User.find(params[:id])
    upcoming_classes_unformatted = user.upcoming_classes
    @upcoming_classes = {}
    @upcoming_classes_arr = []
    upcoming_classes_unformatted.each do |uc|
      @upcoming_classes['weekday_num'] = uc.start_time.wday
      @upcoming_classes['class_time']  = uc.start_time.strftime("%H:%M")
      @upcoming_classes['studio_name']  = uc.klass.name
      @upcoming_classes['neighborhood']  = uc.studio.neighborhood
      @upcoming_classes_arr << @upcoming_classes.clone
    end
    @upcoming_classes_arr.to_json
  end

  get '/data_dump' do  # ALL DATA
    content_type :json
    
    params = AllData.generate_data_dump_params
    data_dump = AllData.new(params)
  
    data_dump.to_json
  end

  ######## API ENDPOINTS END ########

end
