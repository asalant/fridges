class SessionsController < ApplicationController

  def show
    if logged_in?
      @facebook_user = facebook_user
    end
  end
end

