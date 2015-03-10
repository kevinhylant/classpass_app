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

  post "/studio" do
    @studio = Studio.create(params[:studio])
    if @studio.save
      flash[:success] = "Successfully created."
      redirect to "/studios/#{@studio.id}"
    end
  end

  get '/studios/:id' do
    @studio = Studio.find(params[:id])
    erb :studio_show
  end

  get '/instructors' do
    content_type :json
    @instructors = Instructor.all(:order => :last_name)

    @instructors.to_json
  end

  get '/data_dump' do
    content_type :json
    
    params = AllData.generate_data_dump_params
    data_dump = AllData.new(params)
  
    data_dump.to_json
  end

end
