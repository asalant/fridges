class ApplicationController < ActionController::Base
  include FacebookHelper

  protect_from_forgery

end
