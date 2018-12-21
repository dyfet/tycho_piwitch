require_relative 'webkit'

class Restful < Webkit
  get '/' do
    json(
      :name => 'restful', 
      :project => PROJECT_NAME, 
      :version => PROJECT_VERSION
    )
  end
end

