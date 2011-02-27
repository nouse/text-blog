require 'bundler/setup'
require 'steak'
require 'capybara/rspec'
require 'sinatra'

set :env, :test
Capybara.app = Sinatra::Application

SINATRA_ROOT = File.dirname(__FILE__)+'/..'
$LOAD_PATH << SINATRA_ROOT
set :root, SINATRA_ROOT
set :dump_errors, true

require 'app'
