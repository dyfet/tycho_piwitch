require './actions.rb'
require './restful.rb'

map '/actions' do
  run Actions
end

map '/restful' do
  run Restful
end
