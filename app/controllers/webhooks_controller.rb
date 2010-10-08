class WebhooksController < ApplicationController
  def sendgrid
    puts "Got incoming sendgrid email:\n#{params.inspect}"
    render :status => :ok, :nothing =>  true
  end

end
