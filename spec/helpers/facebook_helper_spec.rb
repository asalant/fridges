require 'spec_helper'

describe FacebookHelper do

  context "without facebook cookies" do
    it "should be logged out" do
      helper.logged_in?.should be_false
    end
    it "should not have a user" do
      helper.facebook_user.should_not be_present
    end
  end

  context "with facebook cookies" do
    before do
      helper.stub!(:cookies).and_return({'fbs_108930639170269' => "\"access_token=108930639170269|2.KgSGonpvGpxT5IgaN228SA__.3600.1286863200-548504059|A_pAgTnEuwAcIelMj2H2Wyuufsw&base_domain=localhost.local&expires=1286863200&secret=2hOKs2SxhyioDkyLDSg34A__&session_key=2.KgSGonpvGpxT5IgaN228SA__.3600.1286863200-548504059&sig=c1cec187c7c23d68f9bc4411c49cf671&uid=548504059\""})
      Time.should_receive(:now).any_number_of_times.and_return(Time.at(1286863200 - 100)) # For expires check by Koala
    end

    it "should find cookies" do
      helper.facebook_cookies.should be_present
    end

    it "should be logged in" do
      helper.logged_in?.should be_true
    end

    context "with user info" do
      before do
        Koala::Facebook::GraphAPI.should_receive(:new).and_return(mock(:get_object => {"id"=>"548504059", "name"=>"Alon Salant", "first_name"=>"Alon", "last_name"=>"Salant", "link"=>"http://www.facebook.com/asalant", "gender"=>"male", "email"=>"alon@salant.org", "timezone"=>-7, "locale"=>"en_US", "verified"=>true, "updated_time"=>"2010-08-06T04:19:59+0000"}))
      end

      it "should have a facebook user" do
        user = helper.facebook_user
        user.should be_present
      end
    end

    context "with invalid access token" do
      before do
        graph_mock = mock()
        graph_mock.should_receive(:get_object).any_number_of_times.and_raise(Koala::Facebook::APIError)
        Koala::Facebook::GraphAPI.should_receive(:new).any_number_of_times.and_return(graph_mock)
      end
      
      it "should be logged in" do
        helper.logged_in?.should be_true
      end

      it "should not have a user" do
        helper.facebook_user.should_not be_present
      end

      it "should be logged out after failed user lookup" do
        helper.facebook_user
        helper.logged_in?.should be_false
      end
    end
  end

end
