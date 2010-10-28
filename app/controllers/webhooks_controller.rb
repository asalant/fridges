class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def sendgrid
    Rails.logger.info "Got incoming sendgrid email:\n#{params.inspect}"

    begin
      attributes = { :photo => params['attachment1'], :name => params['subject'], :description => params['text'] }
      from = params[:from] =~ /<([\w@\.]+?)>/ ? $1 : params[:from]
      if user = User.find_by_email(from)
        attributes[:user] = user
      else
        attributes[:email_from] = from
      end
      Fridge.create! attributes
    rescue Exception => e
      Rails.logger.error "Error creating fridge from SendGrid webhook: #{e.message}, #{e.backtrace}"
      HoptoadNotifier.notify(
        :error_class   => "SendGrid Webhook Error",
        :error_message => "#{e.message}",
        :parameters    => params
      )
    end

    render :status => :ok, :nothing =>  true
  end

end
