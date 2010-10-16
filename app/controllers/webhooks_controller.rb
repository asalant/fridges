class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def sendgrid
    Rails.logger.info "Got incoming sendgrid email:\n#{params.inspect}"

    begin
      attributes = { :photo => params['attachment1'], :name => params['subject'], :description => params['text'] }
      if user = User.find_by_email(params[:from])
        attributes[:user] = user
      else
        attributes[:email_from] = params[:from]
      end
      Fridge.create! attributes
    rescue Exception => e
      Rails.logger.error "Error creating fridge from sendgrid webhook: #{e.message}, #{e.backtrace}"
    end

    render :status => :ok, :nothing =>  true
  end

end
