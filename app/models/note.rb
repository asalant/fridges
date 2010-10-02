class Note < ActiveRecord::Base
  belongs_to :fridge

  validates_presence_of :fridge_id
end
