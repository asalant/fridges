require 'spec_helper'

describe User do
  describe "#create_from_facebook" do
    before do
      @facebook_attributes = {"id"=>"548504059", "name"=>"Alon Salant", "first_name"=>"Alon", "last_name"=>"Salant", "link"=>"http://www.facebook.com/asalant", "gender"=>"male", "email"=>"alon@salant.org", "timezone"=>-7, "locale"=>"en_US", "verified"=>true, "updated_time"=>"2010-08-06T04:19:59+0000"}
    end
    subject { User.create_from_facebook(@facebook_attributes) }
    its(:new_record?) { should be_false }
    its(:facebook_id) { should == @facebook_attributes['id'] }
    its(:facebook_link) { should == @facebook_attributes['link'] }
    its(:facebook_updated_at) { should == @facebook_attributes['updated_time'] }
  end

  describe "#update_from_facebook" do
    before do
      @facebook_attributes = {"id"=>"548504059", "name"=>"Alon Salant", "first_name"=>"Alon Updated", "last_name"=>"Salant", "link"=>"http://www.facebook.com/asalant", "gender"=>"male", "email"=>"alon@salant.org", "timezone"=>-7, "locale"=>"en_US", "verified"=>true, "updated_time"=>"2010-08-06T04:19:59+0000"}
    end
    subject { User.update_from_facebook(@facebook_attributes) }
    its(:first_name) { should == @facebook_attributes['first_name'] }
  end
end
