module FridgesHelper
  def fridge_key_path(fridge)
    "/#{fridge.key}"
  end
  
  def fridge_key_url(fridge)
    fridges_url.gsub /fridges$/, fridge.key
  end

  def location_for(fridge)
    return fridge.location if fridge.location.present?
    return fridge.user.location if fridge.user.present?
    ''
  end
end
