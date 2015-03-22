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


  ######## API ENDPOINTS START ########
  # http://example.com/view_widgets
  # http://example.com/create_new_widget?name=Widgetizer
  # http://example.com/update_widget?id=123&name=Foo
  # http://example.com/delete_widget?id=123


  
  # # create
  # post '/widgets' do
  #   widget = Widget.new(params['widget'])
  #   widget.save
  #   status 201
  # end

  # # update
  # put '/widgets/:id' do
  #   widget = Widget.find(params[:id])
  #   return status 404 if widget.nil?
  #   widget.update(params[:widget])
  #   widget.save
  #   status 202
  # end

  get '/api/users/sample-user' do
    content_type :json
    user = User.all.sample(1)[0]
    @user = user.return_self_and_preferences
    @user.to_json
  end

  get '/api/users/:id/classes/completed' do 
    content_type :json
    user = User.find(params[:id])
    completed_classes = user.return_classes('completed')
    @completed_classes = completed_classes.collect {|cc| cc.return_self_and_associated_objects} 
    @completed_classes.to_json
  end

  get '/api/users/:id/classes/upcoming' do 
    content_type :json
    user = User.find(params[:id])
    upcoming_classes = user.return_classes('upcoming')
    @upcoming_classes = upcoming_classes.collect {|uc| uc.return_self_and_associated_objects} 
    @upcoming_classes.to_json
  end

  get '/api/studios' do
    content_type :json
    studios = Studio.all
    @studios = studios.collect {|studio| studio.return_self_and_associated_objects} 
    @studios.to_json
  end

  get '/api/studio/:id/average_rating' do
    content_type :json
    studio = Studio.find(params[:id])
    ratings_count = 0
    scheduled_classes = studio.scheduled_classes
    stars_array = scheduled_classes.collect do |sc| 
      ratings = sc.ratings
      
      sc_ratings_array = ratings.collect { |rating| rating.star_rating }
      sc_ratings_array.compact!
      ratings_count += sc_ratings_array.size
      sc_star_total = sc_ratings_array.inject(:+)
      sc_star_total
    end
    stars_array.compact!
    stars_total = stars_array.inject(:+).to_f
    @avg_star_rating = (stars_total/ratings_count).round(2)
    @avg_star_rating.to_json
  end


  get '/data_dump' do  # ALL DATA
    content_type :json
    
    params = AllData.generate_data_dump_params
    data_dump = AllData.new(params)
  
    data_dump.to_json
  end

  ######## API ENDPOINTS END ########

end
