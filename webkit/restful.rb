require_relative 'webkit'

class Restful < Sinatra::Base
  set :logging, false
  set :sessions, false
  set :dump_errors, false

  helpers Sinatra::JSON

  get '/' do
    json(
      :name => 'restful', 
      :project => PROJECT_NAME, 
      :version => PROJECT_VERSION
    )
  end
end

