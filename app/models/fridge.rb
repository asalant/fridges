class Fridge < ActiveRecord::Base

  attr_protected :key

  has_attached_file :photo,
    :styles          => {:large => "100%", :large => "100%"},
    :convert_options => {
      :large => "-auto-orient -geometry 600",
      :thumb => "-auto-orient -geometry 100x100#"},

    :storage         => :s3,
    :s3_credentials  => "#{Rails.root}/config/s3.yml",
    :path            => ":class/:style/:id_:filename"

  validates_presence_of :name
  validates_attachment_presence :photo

  after_create :reset_key!

  def reset_key!
    update_attribute(:key, generate_key)
  end

  def self.any(params = {})
    where = {:offset => (Fridge.count * rand).to_i}
    where.merge!({:conditions => ['id not in (?)', params[:except]]}) if params[:except]
    Fridge.first where
  end

  private

  def generate_key
    "#{self.class.name}:#{self.id}".hash.abs.to_s(36)[1..6]
  end

end
