require "spec_helper"

describe UserMailer do
  describe "#fridge_created" do
    subject { UserMailer.fridge_created(fridges(:alon)) }

    its(:to) { should == [users(:alon).email] }
    its(:body) { should =~ /frdg.us\/#{fridges(:alon).key}/ }
  end
end
