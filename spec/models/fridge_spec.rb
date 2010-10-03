require 'spec_helper'

describe Fridge do
  describe "#any" do
    it "should find any one" do
      Fridge.any.should be_present
    end

    it "should not find exceptions" do
      Fridge.any(:except => [fridges(:alon), fridges(:rob)]).should be_nil
    end
  end

  context "when creating" do
    before do
      @fridge = Fridge.new :name => "name", :photo => fixture_file_upload('spec/fixtures/fridge.jpg', 'image/jpeg')
      @fridge.stub!(:save_attached_files).and_return true
    end

    subject { @fridge }
    it { should be_valid }
    it "generates key" do
      @fridge.save!
      @fridge.key.should be_present
      @fridge.key.length.should == 6
    end
  end

  context "for urls" do
    it "should return key for to_param" do
      fridges(:alon).to_param.should == fridges(:alon).key
    end
  end
end
