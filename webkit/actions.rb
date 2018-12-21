require_relative 'apiauth'

class Actions < ApiAuth
  # endpoint generic id followed by post routes...
  get '/' do
    json(
      :name => 'actions', 
      :project => PROJECT_NAME, 
      :version => PROJECT_VERSION
    )
  end

end

