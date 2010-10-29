require 'spec_helper'

describe Note do

  describe "#owned_by?" do
    context "when existing" do
      subject { notes(:alon_one) }
      it { should be_owned_by(users(:alon)) }
      it { should_not be_owned_by(nil) }
    end
    context "when new" do
      subject { Note.new }
      it { should_not be_owned_by(users(:alon)) }
      it { should_not be_owned_by(nil) }
    end
  end

  describe "#create" do
    it "increments notes_count on create" do
      Note.create! :fridge => fridges(:alon)
      fridges(:alon).notes_count.should == fridges(:alon).notes.count
    end
  end

  describe "#destroy" do
    it "decrements notes_count" do
      notes(:alon_two).destroy
      fridges(:alon).notes_count.should == fridges(:alon).notes.count
    end

  end
end
