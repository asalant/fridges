require 'spec_helper'

describe Fridge do
  before do
    AWS::S3::Base.stubs(:establish_connection!)
    Fridge.any_instance.stubs(:save_attached_files)
    Fridge.any_instance.stubs(:destroy_attached_files)
  end

  describe "#any" do
    it "should find any one" do
      Fridge.any.should be_present
    end

    it "should not find exceptions" do
      Fridge.any(:except => [fridges(:alon), fridges(:rob)]).should be_nil
    end
  end




  describe "#owned_by?" do
    context "when existing" do
      subject { fridges(:alon) }
      it { should be_owned_by(users(:alon)) }
      it { should_not be_owned_by(nil) }
    end
    context "when new" do
      subject { Fridge.new }
      it { should_not be_owned_by(users(:alon)) }
      it { should_not be_owned_by(nil) }
    end
  end

  context "when creating" do
    subject { Fridge.create :photo => fixture_file_upload('spec/fixtures/fridge.jpg', 'image/jpeg') }
    it { should be_valid }
    it "generates key" do
      subject.key.should be_present
      subject.key.length.should == 6
    end
  end


  context "when creating with user" do
    subject { Fridge.create :user => users(:alon), :location=> 'location', :photo => fixture_file_upload('spec/fixtures/fridge.jpg', 'image/jpeg') }
    it { should be_valid }

    it "copies location to user" do
      subject.user.location.should == 'location'
    end
  end
end
