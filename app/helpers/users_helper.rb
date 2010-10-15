module UsersHelper
  def profile_image_url(user)
  "http://graph.facebook.com/#{user.facebook_id}/picture"
  end
end
