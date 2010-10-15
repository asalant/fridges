class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :oauthable
  devise :database_authenticatable, :rememberable, :trackable, :oauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :gender, :locale, :timezone, :facebook_id

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = ActiveSupport::JSON.decode(access_token.get('https://graph.facebook.com/me?'))
    if user = User.find_by_email(data["email"])
      user
    else # Create an user with a stub password.
      self.create_from_facebook(data)
    end
  end

  def self.create_from_facebook(data)
    User.create!(attributes_from_facebook(data).merge :password => Devise.friendly_token[0,20])
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def short_name
    [first_name, "#{last_name[0,1]}."].join(" ")
  end

  private

  def self.attributes_from_facebook(user_info)
    attributes = { :facebook_id                => user_info['id'] }
    %w(first_name last_name email gender locale timezone).each { |key| attributes[key] = user_info[key] }
    attributes
  end
end
