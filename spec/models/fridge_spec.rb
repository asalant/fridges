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

  context "when creating" do
    subject { Fridge.create :name => "name", :photo => fixture_file_upload('spec/fixtures/fridge.jpg', 'image/jpeg') }
    it { should be_valid }
    it "generates key" do
      subject.key.should be_present
      subject.key.length.should == 6
    end
  end
end
