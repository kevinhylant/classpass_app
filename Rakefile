require "sinatra/activerecord/rake"
require './app'
 
desc "run irb console"
task :console, :environment do |t, args|
  ENV['RACK_ENV'] = args[:environment] || 'development'
 
  exec "irb -r irb/completion -r './app'"
end