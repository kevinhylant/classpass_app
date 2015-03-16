ENV['RACK_ENV'] ||= "development"

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

require 'sinatra/base'
require 'sinatra/reloader'
require 'pry'
require "active_support/all"
require "chronic"
require "thin"

require './app'
