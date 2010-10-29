class Note < ActiveRecord::Base
  belongs_to :fridge

  validates_presence_of :fridge_id

  after_create :update_fridge_notes_count
  after_destroy :update_fridge_notes_count

  def owned_by?(user)
    fridge.present? && fridge.user.present? && (fridge.user == user)
  end

  private

  def update_fridge_notes_count
    fridge.update_attribute :notes_count, fridge.notes.count
  end
end
