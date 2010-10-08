require 'spec_helper'

describe WebhooksController do

  describe "POST sendgrid" do
    before do
      file = File.new('spec/fixtures/fridge.jpg')
      Fridge.should_receive(:create!).with hash_including(:name => 'Subject', :description => "Text", :photo => file)
      params = {
        "from"=>"alon@salant.org", "to"=>"upload@frdg.us\n", "dkim"=>"none",
        "subject"=>"Subject", "text"=>"Text",
        "attachment1"=> file, "attachment2"=>File.new('spec/fixtures/fridge.jpg'), "SPF"=>"none", "attachments"=>"2",
        "headers"=>"Received: by 127.0.0.1 with SMTP id BWgZQVgi28\n        Fri, 08 Oct 2010 00:23:20 -0500 (CDT)\nReceived: from mail-bw0-f50.google.com (mail-bw0-f50.google.com [209.85.214.50])\n\tby mx2.sendgrid.net (Postfix) with ESMTP id D341E17866A8\n\tfor <upload@frdg.us>; Fri,  8 Oct 2010 00:23:18 -0500 (CDT)\nReceived: by bwz17 with SMTP id 17so496983bwz.23\n        for <upload@frdg.us>; Thu, 07 Oct 2010 22:23:17 -0700 (PDT)\nReceived: by 10.204.103.199 with SMTP id l7mr1397015bko.18.1286515397634;\n        Thu, 07 Oct 2010 22:23:17 -0700 (PDT)\nReceived: from [10.0.1.193] (204-195-75-139.wavecable.com [204.195.75.139])\n        by mx.google.com with ESMTPS id v7sm2284749bkx.4.2010.10.07.22.23.11\n        (version=TLSv1/SSLv3 cipher=RC4-MD5);\n        Thu, 07 Oct 2010 22:23:15 -0700 (PDT)\nSubject: Another try\nFrom: Alon Salant <alon@salant.org>\nContent-Type: multipart/mixed; boundary=Apple-Mail-2--1029484047\nMessage-Id: <657571C3-02CF-457A-8A2C-181D727B3396@salant.org>\nDate: Thu, 7 Oct 2010 22:22:41 -0700\nTo: upload@frdg.us\nContent-Transfer-Encoding: 7bit\nMime-Version: 1.0 (iPhone Mail 8B117)\nX-Mailer: iPhone Mail (8B117)\n"}

      post :sendgrid, params
    end

    subject {response}
    it {should be_success}
  end

end
