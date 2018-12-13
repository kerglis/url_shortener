class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :server_host

  def server_host
    @server_host ||= "#{request.protocol}#{request.host_with_port}/"
  end
end
