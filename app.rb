require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'pry'

require './studio'
require './clss'
require './instructor'


class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get "/" do
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
    binding.pry
    @studio = Studio.build(:name => params[:name],
                            :description => paramas[:description])
    if @studio.save
      redirect to "/studio/#{@studio.id}", :notice => "Studio successfully created"
    end
  end

  get '/studios/:id' do
    erb :studio_show
  end


end
