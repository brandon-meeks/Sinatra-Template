module Sinatra
  module ApplicationHelpers
    def authenticity_token
      session[:csrf] = SecureRandom.hex(128) unless session.has_key?(:csrf)
      %(<input type="hidden" name="authenticity_token" value="#{session[:csrf]}"/>)
    end
  end
end
