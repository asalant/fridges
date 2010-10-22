class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    puts "Session: #{session.inspect}"
  end

end
