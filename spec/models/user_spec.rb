require 'spec_helper'

describe User do
  describe "#create_from_facebook" do
    before do
      @facebook_attributes = {"id"=>"548504059", "name"=>"Alon Salant", "first_name"=>"Alon", "last_name"=>"Salant", "link"=>"http://www.facebook.com/asalant", "gender"=>"male", "email"=>"alon@example.com", "timezone"=>-7, "locale"=>"en_US", "verified"=>true, "updated_time"=>"2010-08-06T04:19:59+0000"}
    end
    subject { User.create_from_facebook(@facebook_attributes) }
    its(:email) { should be_present }
    its(:password) { should be_present }
    its(:new_record?) { should be_false }
    its(:facebook_id) { should == @facebook_attributes['id'] }
  end
end
