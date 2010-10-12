class User < ActiveRecord::Base

  def self.create_from_facebook(user_info)
    create(attributes_from_facebook(user_info))
  end

  def self.update_from_facebook(user_info)
    user = User.find_by_facebook_id(user_info['id'])
    user.update_attributes(attributes_from_facebook(user_info))
    user
  end

  private
  
  def self.attributes_from_facebook(user_info)
    attributes = {
      :facebook_id                => user_info['id'],
      :facebook_link              => user_info['link'],
      :facebook_updated_at        => DateTime.parse(user_info['updated_time'])
    }
    %w(first_name last_name email gender locale timezone).each { |key| attributes[key] = user_info[key] }
    attributes
  end
end
