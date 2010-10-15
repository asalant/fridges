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
end
