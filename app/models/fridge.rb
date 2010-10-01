class Fridge < ActiveRecord::Base
  has_attached_file :photo,
    :styles         => {:large => "700", :thumb => "100x100#"},
    :storage        => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "/:style/:filename"
end
