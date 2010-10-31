class UserMailer < ActionMailer::Base
  default :from => "hello@checkoutmyfridge.com"
  add_template_helper(FridgesHelper)
  default_url_options[:host] = 'frdg.us'

  def your_fridge(fridge)
    @fridge = fridge
    mail(:to => fridge.user.email,  :subject => "Check Out Your Fridge!")
  end

  def claim_fridge(fridge)
    @fridge = fridge
    mail(:to => fridge.email_from,  :subject => "Claim Your Fridge!")
  end
end
