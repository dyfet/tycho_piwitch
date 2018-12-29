case ENV['RACK_ENV']
when /coverage/
  require 'simplecov'
  SimpleCov.start do
    SimpleCov.command_name 'Unit Tests'
  end
end

require './actions.rb'
require './restful.rb'

map '/actions' do
  run Actions
end

map '/restful' do
  run Restful
end
