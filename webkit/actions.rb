require_relative 'apiauth'

class Actions < ApiAuth
  # standard rpc action post handlers to be added...
  METHODS = [].freeze
  get '/' do
    json(name: endpoint, project: PROJECT_NAME, version: PROJECT_VERSION, methods: METHODS)
  end
end
