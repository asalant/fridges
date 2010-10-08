class SessionsController < ApplicationController

  # Switch to http://github.com/arsduo/koala/wiki/koala-on-rails
  def show
    @graph = Koala::Facebook::GraphAPI.new(facebook_cookies['access_token'])
    begin
      @user = @graph.get_object("me")
    rescue Exception => e
      @user = nil
      Rails.logger.warn "Error getting user details from Facebook: #{e}"
    end
  end
end
