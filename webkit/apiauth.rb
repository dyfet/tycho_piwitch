require_relative 'webkit'

# actually "X-API-AUTHORIZATION" header going into rack...
API_AUTHORIZATION = 'HTTP_X_API_AUTHORIZATION'

class ApiAuth < Sinatra::Base
  set :logging, false
  set :sessions, false
  set :dump_errors, false

  attr_reader :identity

  helpers Sinatra::JSON

  def authorized?
    return identity != nil
  end

  # convenience verification functions we can put in route handlers
  def authorization_required
    halt 401, "Authorization required" if !authorized?
  end

  def admin_access_required
    authorization_required
    db = Webkit.db
    # TODO: test if authorizing identity is in admin table
  end

  before do
    @identity = nil
    return if env[API_AUTHORIZATION] == nil      # no auth header, so skip
    if env[API_AUTHORIZATON] && env[API_AUTHORIZATION].split(':').length == 2
      auth = env['HTTP_AUTHORIZATION'].split(':')
    else
      halt 401
    end
    data = request.path
    data = "#{data}?#{request.query_string}" if request.query_string.present?
    if ['POST', 'PUT', 'PATCH'].include? request.request_method
      request.body.rewind
      data += request.body.read
    end
    # TODO: verify auth id against request signed by the endpoint web token,
    # on success reset env with effective authorization actually used
    @identity = auth[0]
  end
end
