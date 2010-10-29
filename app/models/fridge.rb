class Fridge < ActiveRecord::Base
  belongs_to :user
  has_many :notes

  attr_protected :key

  has_attached_file :photo,
    {
      :styles            => {:large => "100%", :thumb => "100x100#"},
      :convert_options   => {
        :large => "-auto-orient -geometry 600",
        :thumb => "-auto-orient"}
    }.merge(PAPERCLIP_STORAGE_OPTIONS)

  validates_attachment_presence :photo

  after_initialize :set_defaults
  before_create :reset_key
  after_create :send_email

  scope :with_key, lambda { |key|
    where(:key => key)
  }

  scope :owned, :conditions => 'user_id is not null'

  def reset_key
    until Fridge.with_key(key = ActiveSupport::SecureRandom.hex(3)).empty? do
      ;
    end
    self.key = key
  end

  def reset_claim_token!
    update_attribute :claim_token, ActiveSupport::SecureRandom.hex(8)
  end

  def self.any(params = {})
    owned.offset((Fridge.count * rand).to_i - 1).where(['id not in (?)', params[:except] || 0]).first
  end

  def claim_by!(user)
    update_attributes!(:user => user, :claim_token => nil)
    send_email
  end

  def owned_by?(user)
    self.user.present? && (self.user == user)
  end

  def count_view!
    update_attribute :view_count, view_count + 1
  end

  private

  def set_defaults
    self.view_count ||= 0
    self.notes_count ||= 0
  end

  def generate_key
    ActiveSupport::SecureRandom.hex(3)
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
