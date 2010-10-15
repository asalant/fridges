module UsersHelper
  def profile_image_url(user)
    return nil if user.nil?
    "http://graph.facebook.com/#{user.facebook_id}/picture"
  end
end
