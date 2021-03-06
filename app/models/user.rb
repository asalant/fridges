class User < ActiveRecord::Base
  has_many :fridges
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :oauthable
  devise :database_authenticatable, :rememberable, :trackable, :oauthable

  attr_accessor :facebook_access_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :gender, :locale, :timezone, :location, :facebook_id

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = ActiveSupport::JSON.decode(access_token.get('https://graph.facebook.com/me?'))
    Rails.logger.debug "User#find_for_facebook_oauth data: #{data.inspect}"
    unless user = User.find_by_email(data["email"])
      # Create an user with a stub password.
      user = self.create_from_facebook(data)
    end
    user.facebook_access_token = access_token
    user
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

  def admin?
    role == 'admin'
  end

  private

  def self.attributes_from_facebook(user_info)
    attributes = { :facebook_id => user_info['id'] }
    %w(first_name last_name email gender locale timezone).each { |key| attributes[key] = user_info[key] }
    if user_info['location']
      attributes[:location] = user_info['location']['name']
    elsif user_info['hometown']
      attributes[:location] = user_info['hometown']['name']
    end
    attributes
  end
end
