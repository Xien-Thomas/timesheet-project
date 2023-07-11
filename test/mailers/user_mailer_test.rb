require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

    def setup
        @vendor = vendors(:vendor1)
        @body = "this is a body paragraph"
    end 

    test 'send a message to the correct group of contractors' do
        email = UserMailer.with(body: @body, vendor: @vendor.id).send_contract_message

        assert_equal email.from, ["no-reply@aoi.com"]
        assert_equal email.subject, "Contractor Timesheet approval"
        assert_match 'this is a body paragraph', email.body.encoded
    end
end