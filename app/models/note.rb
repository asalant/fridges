class Note < ActiveRecord::Base
  belongs_to :fridge

  validates_presence_of :fridge_id

  def owned_by?(user)
    fridge.present? && fridge.user.present? && (fridge.user == user)
  end
end
