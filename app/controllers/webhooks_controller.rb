class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def sendgrid
    Rails.logger.info "Got incoming sendgrid email:\n#{params.inspect}"

    begin
      Fridge.create!(:photo => params['attachment1'], :name => params['subject'], :description => params['text'])
    rescue Exception => e
      Rails.logger.error "Error creating fridge from sendgrid webhook: #{e.message}, #{e.backtrace}"
    end

    render :status => :ok, :nothing =>  true
  end

end
