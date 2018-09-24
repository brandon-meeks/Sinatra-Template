require_relative '../helpers/application_helper'
module Routes
  class ApplicationRoutes < Sinatra::Base
    set :views, File.expand_path('../../views', __FILE__)

    # Helpers
    helpers Sinatra::ApplicationHelpers

    # App index page
    get '/' do
      haml :index
    end
  end
end