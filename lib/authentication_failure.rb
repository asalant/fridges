module Facebook
  class AuthenticationFailure < Devise::FailureApp
    include Devise::Oauth::UrlHelpers

    def redirect_url
      user_oauth_authorize_url(:facebook)
    end
  end
end