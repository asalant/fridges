module UsersHelper
  def profile_image_url(user)
    return 'profile_placeholder.jpg' if user.nil?
    "http://graph.facebook.com/#{user.facebook_id}/picture"
  end
end
