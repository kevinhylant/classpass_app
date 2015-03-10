ENV['RACK_ENV'] ||= "test"

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

require 'rack/test'
require 'sinatra/base'
require 'sinatra/reloader'
require './app'
require "active_support/all"
require "chronic"
require 'pry'

