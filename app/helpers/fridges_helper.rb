module FridgesHelper
  def fridge_key_path(fridge)
    "/#{fridge.key}"
  end
  
  def fridge_key_url(fridge)
    fridges_url.gsub /fridges$/, fridge.key
  end
end
