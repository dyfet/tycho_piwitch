require_relative 'apiauth'

class Restful < ApiAuth
  get '/' do
    json(
      :name => 'restful', 
      :project => PROJECT_NAME, 
      :version => PROJECT_VERSION
    )
  end
end

