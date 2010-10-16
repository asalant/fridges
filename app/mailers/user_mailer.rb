class UserMailer < ActionMailer::Base
  default :from => "contact@checkoutmyfridge.com"
  add_template_helper(FridgesHelper)
  default_url_options[:host] = 'frdg.us'

  def your_fridge(fridge)
    @fridge = fridge
    mail(:to => fridge.user.email,  :subject => "Check out your fridge!")
  end

  def claim_fridge(fridge)
    @fridge = fridge
    mail(:to => fridge.email_from,  :subject => "Claim your fridge!")
  end
end
