require 'spec_helper'

describe WebhooksController do

  describe "POST sendgrid" do
    before do
      post :sendgrid
    end

    subject {response}
    it {should be_success}
  end

end
