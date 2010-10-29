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

  describe "#count_view!" do
    context "when new" do
      its(:view_count) { should == 0 }
    end

    subject { fridges(:alon) }
    it "should increment view_count" do
      fridges(:alon).count_view!
      fridges(:alon).view_count.should == 1
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

  describe "#claim_by!" do
    before do
      UserMailer.expects("your_fridge").returns(stub(:deliver))
      fridges(:unclaimed).claim_by!(users(:alon))
    end
    subject { fridges(:unclaimed) }
    its(:claim_token) { should be_nil }
    it { should be_owned_by(users(:alon)) }
  end

  context "when creating" do
    subject { Fridge.create :photo => fixture_file_upload('spec/fixtures/fridge.jpg', 'image/jpeg') }
    it { should be_valid }
    it "generates key" do
      subject.key.should be_present
      subject.key.length.should == 6
    end

    its(:notes_count) { should == 0 }
  end

  context "when creating with user" do
    before do
      UserMailer.expects("your_fridge").with do |fridge|
        fridge.key.should be_present
      end.returns(stub(:deliver))
    end

    subject { Fridge.create :user => users(:alon), :location=> 'location', :photo => fixture_file_upload('spec/fixtures/fridge.jpg', 'image/jpeg') }
    it { should be_valid }
  end


  context "when creating from email" do
    before do
      UserMailer.expects("claim_fridge").with do |fridge|
        fridge.claim_token.should be_present
      end.returns(stub(:deliver))
    end

    subject { Fridge.create :email_from => 'from@example.com', :photo => File.new('spec/fixtures/fridge.jpg') }
    it { should be_valid }
    its(:claim_token) { should be_present }
  end
end
