class Fridge < ActiveRecord::Base
  belongs_to :user
  has_many :notes

  attr_protected :key

  has_attached_file :photo,
    :styles          => {:large => "100%", :thumb => "100x100#"},
    :convert_options => {
      :large => "-auto-orient -geometry 600",
      :thumb => "-auto-orient"},

    :storage         => :s3,
    :s3_credentials  => "#{Rails.root}/config/s3.yml",
    :path            => ":class/:style/:id_:filename"

  validates_attachment_presence :photo

  before_create :reset_key
  after_create :copy_location_to_user, :send_email

  scope :with_key, lambda { |key|
    where(:key => key)
  }

  def reset_key
    until Fridge.with_key(key = ActiveSupport::SecureRandom.hex(3)).empty? do; end
    self.key = key
  end

  def reset_claim_token!
    update_attribute(:claim_token, ActiveSupport::SecureRandom.hex(8))
  end

  def self.any(params = {})
    where = {:offset => (Fridge.count * rand).to_i}
    where.merge!({:conditions => ['id not in (?)', params[:except]]}) if params[:except]
    Fridge.first where
  end

  def claim_by(user)
    update_attributes!(:user => user, :claim_token => nil)
    send_email
  end

  def owned_by?(user)
    self.user.present? && (self.user == user)
  end

  private

  def generate_key
    ActiveSupport::SecureRandom.hex(3)
  end

  def copy_location_to_user
    if location.present? && user.present?
      user.update_attribute :location, location
    end
  end

  def send_email
    if user.present?
      UserMailer.your_fridge(self).deliver
    elsif email_from.present?
      reset_claim_token!
      UserMailer.claim_fridge(self).deliver
    end
  end

end
