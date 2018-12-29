require_relative 'webkit'
require 'pp'

# actually "X-API-AUTHORIZATION" header going into rack...
API_AUTHORIZATION = 'HTTP_X_API_AUTHORIZATION'.freeze

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
    halt 401, 'Authorization required' unless authorized?
  end

  def local_access_required
    authorization_required
    halt 401, 'Local access required' if @identity.include? '@'
  end

  def admin_access_required
    local_access_required
    halt 401, 'Admin access required' unless admin?
  end

  # checks we have
  def authorized?
    @identity != nil
  end

  def admin?
    _db = Webkit.db
    # TODO: test if authorizing identity is in admin table
    false
  end

  # authorization logic in front of all routes...
  before do
    @identity = nil
    @extension = 0
    @endpoint = (@env['HTTP_X_FORWARDED_HOST'] || @env['HTTP_HOST'] || @env['SERVER_NAME']).gsub(/:\d+\z/, '') + '/' + env['REQUEST_PATH'][1..-1][/^.+?(?=\/|$)/]
    # exit early if no auth header to process...
    return if env[API_AUTHORIZATION].nil?

    # While in theory the endpoint can be faked, you already have to know
    # the underlying secret stored for the user to compute a valid web token
    # to seed the digest.  If you know the secret already you do not need
    # bother faking the endpoint, and if you don't, it does not matter if
    # you do.  Incidentally this also means that www.xxx.yyy and xxx.yyy do
    # have different token values even if they map to the same server.

    # Please also note that different endpoints, like restful and actions,
    # may also have different tokens.  It is possible some api endpoints may be
    # forwarded from a public website, while others, such as restful, are
    # only accessed entirely private or locally.

    if env[API_AUTHORIZATION].split(':').length == 2
      @identity, _digest = env['HTTP_AUTHORIZATION'].split(':')
    else
      halt 401, 'Invalid authorization header'
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

  # any common api handlers, can be overridden
  get '/' do
    json(name: endpoint, project: PROJECT_NAME, version: PROJECT_VERSION)
  end
end
