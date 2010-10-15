class UserMailer < ActionMailer::Base
  default :from => "Check Out My Fridge <contact@checkoutmyfridge.com>"
  add_template_helper(FridgesHelper)
  default_url_options[:host] = 'frdg.us'


  def fridge_created(fridge)
    @fridge = fridge
    mail(:to => fridge.user.email,  :subject => "Check out your fridge!")
  end
end
