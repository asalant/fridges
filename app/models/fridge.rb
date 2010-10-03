class Fridge < ActiveRecord::Base

  attr_protected :key

  has_attached_file :photo,
    :styles         => {:large => "600", :thumb => "100x100#"},
    :storage        => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":class/:style/:id_:filename"

  validates_presence_of :name
  validates_attachment_presence :photo

  after_create { update_attribute(:key, generate_key) }

  private

  def generate_key
    "#{self.class}:#{self.id}".hash.abs.to_s[1..6]
  end

end
