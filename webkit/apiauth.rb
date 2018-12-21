require_relative 'webkit'

# actually "X-API-AUTHORIZATION" header going into rack...
API_AUTHORIZATION = 'HTTP_X_API_AUTHORIZATION'

class ApiAuth < Sinatra::Base
  set :logging, false
  set :sessions, false
  set :dump_errors, false

  helpers Sinatra::JSON

  def authorized?
    return env[API_AUTHORIZATION] != nil
  end

  def authorized
    return env[API_AUTHORIZATION]
  end

  before do
    return if !authorized?      # no auth header, so skip
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
    env[API_AUTHORIZATION] = auth[0]
  end
end
