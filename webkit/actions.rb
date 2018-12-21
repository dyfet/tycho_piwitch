require_relative 'webkit'

class Actions < Webkit
  get '/' do
    json(
      :name => 'actions', 
      :project => PROJECT_NAME, 
      :version => PROJECT_VERSION
    )
  end
end

