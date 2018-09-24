require 'sinatra/base'
require 'sinatra/flash'
require 'rack-flash'
require 'sinatra/activerecord'
require 'sinatra/namespace'
require 'sinatra/contrib'
require 'shotgun'
require 'logger'

# Pull in route/helper files and require them
Dir[File.join(File.dirname(__FILE__), 'routes', '*.rb')].each { |file| require_relative file }

ENV['RACK_ENV'] ||= 'development'

class App < Sinatra::Base
  register Sinatra::Contrib
  register Sinatra::ActiveRecordExtension

  set :root, File.dirname(__FILE__)
  set :database_file, 'config/database.yml'
  set :static, true

  # Rack Protection Settings
  set :protection, true
  set :protect_from_csrf, true

  # Session Settings
  enable :sessions
  set :session_secret, 'my-secret'
  set :cookie_option, path: '/'
  use Rack::Protection::AuthenticityToken
  use Rack::Protection::FormToken

  # Flash Messages
  use Rack::Flash

  # Routes
  use Routes::ApplicationRoutes

  # Set 404 page template
  not_found do
    haml :not_found
  end

  # Enable logging in development and production
  configure :production, :development do
    logger = Logger.new("#{root}/logs/#{environment}.log", 'weekly')
    logger.level = Logger::DEBUG if development?
    set :logger, logger
    # Enable logging of ActiveRecord
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

end
