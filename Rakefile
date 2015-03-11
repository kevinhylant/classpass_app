require "sinatra/activerecord/rake"
require './app'
 
desc "run irb console"
task :console, :environment do |t, args|
  ENV['RACK_ENV'] = args[:environment] || 'development'
 
  exec "irb -r irb/completion -r './app'"
end

desc "seed database"
namespace :db do
  task :seed, :environment do |t, args|
    ENV['RACK_ENV'] = args[:environment] || 'development'
    MyFactory.seed_database('small')
  end
end

desc "destroy all database records"
namespace :db do
  task :destroy_all, :environment do |t, args|
    ENV['RACK_ENV'] = args[:environment] || 'development'
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end
end


