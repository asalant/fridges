module FacebookHelper

  def logged_in?
    facebook_cookies.present? && facebook_cookies['access_token'].present?
  end

  def facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
  end

  def facebook_user
    if logged_in?
      begin
        @facebook_user ||= Koala::Facebook::GraphAPI.new(facebook_cookies['access_token']).get_object("me")
      rescue Koala::Facebook::APIError => e
        facebook_cookies.delete 'access_token'
        nil
      end
    end
  end

end
