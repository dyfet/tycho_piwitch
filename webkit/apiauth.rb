require_relative 'webkit'
require 'pp'

# actually "X-API-AUTHORIZATION" header going into rack...
API_AUTHORIZATION = 'HTTP_X_API_AUTHORIZATION'

class ApiAuth < Sinatra::Base
  set :logging, false
  set :sessions, false
  set :dump_errors, false

  attr_reader :identity
  attr_reader :endpoint
  attr_reader :extension

  helpers Sinatra::JSON

  # convenience verification functions we can put in route handlers
  def authorization_required
    halt 401, "Authorization required" if !authorized?
  end

  def local_access_required
    authorization_required
    halt 401, "Local access required" if @identity.include? '@'
  end      

  def admin_access_required
    local_access_required
    halt 401, "Admin access required" if !admin?
  end

  # checks we have
  def authorized?
    @identity != nil
  end

  def admin?
    db = Webkit.db
    # TODO: test if authorizing identity is in admin table
    false
  end

  # authorization logic in front of all routes...
  before do
    @identity = nil
    @endpoint = env['SERVER_NAME'] + ':' + env['SERVER_PORT']
    @extension = 0
    # if we use the base uri also for the web token comp, but this means
    # paths are locked and user has to create multiple tokens...
    # + ':' + env['REQUEST_PATH'][1..-1][/^.+?(?=\/|$)/]

    # exit early if no auth header to process...
    return if env[API_AUTHORIZATION] == nil 

    if env[API_AUTHORIZATION].split(':').length == 2
      @identity, signature = env['HTTP_AUTHORIZATION'].split(':')
    else
      halt 401, "Invalid authorization header"
    end
    data = request.path
    data = "#{data}?#{request.query_string}" if request.query_string.present?
    if ['POST', 'PUT', 'PATCH'].include? request.request_method
      request.body.rewind
      data += request.body.read
    end
    # TODO: verify auth id against request signed by the endpoint web token,
    # on success reset env with effective authorization actually used
  end
end
