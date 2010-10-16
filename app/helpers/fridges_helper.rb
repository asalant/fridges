module FridgesHelper

  def location_for(fridge)
    return fridge.location if fridge.location.present?
    return fridge.user.location if fridge.user.present?
    ''
  end
end
