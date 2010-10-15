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

  after_create :reset_key!, :copy_location_to_user

  def reset_key!
    update_attribute(:key, generate_key)
  end

  def self.any(params = {})
    where = {:offset => (Fridge.count * rand).to_i}
    where.merge!({:conditions => ['id not in (?)', params[:except]]}) if params[:except]
    Fridge.first where
  end

  def owned_by?(user)
    self.user.present? && (self.user == user)
  end

  private

  def generate_key
    "#{self.class.name}:#{self.id}".hash.abs.to_s(36)[1..6]
  end

  def copy_location_to_user
    if location.present? && user.present?
      user.update_attribute :location, location
    end
  end

end
