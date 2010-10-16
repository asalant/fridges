require "spec_helper"

describe UserMailer do
  describe "#your_fridge" do
    subject { UserMailer.your_fridge(fridges(:alon)) }

    its(:to) { should == [users(:alon).email] }
    its(:body) { should =~ %r(<html>) }
    its(:body) { should =~ %r(frdg.us/#{fridges(:alon).key}) }
  end

  describe "#claim_fridge" do
    subject { UserMailer.claim_fridge(fridges(:unclaimed)) }

    its(:to) { should == [fridges(:unclaimed).email_from] }
    its(:body) { should =~ %r(frdg.us/claim/#{fridges(:unclaimed).claim_token}) }
  end
end
