class Fridge < ActiveRecord::Base
  has_attached_file :photo, :styles => { :large => "700", :thumb => "100x100#" }

end
