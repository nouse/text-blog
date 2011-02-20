require 'bundler/setup'
require 'spork'

Spork.prefork do
  require 'steak'
  require 'capybara/rspec'
  require 'sinatra'

  set :env, :test
  Capybara.app = Sinatra::Application

  SINATRA_ROOT = File.dirname(__FILE__)+'/..'
  $LOAD_PATH << SINATRA_ROOT
  set :root, SINATRA_ROOT
end

Spork.each_run do
  require 'app'
end
