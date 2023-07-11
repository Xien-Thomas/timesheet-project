class UserMailer < ApplicationMailer
    #Set the default FROM and SUBJECT attributes
    default from: "no-reply@aoi.com", 
        subject: "Contractor Timesheet approval"

    #definition to send the mail to the email recipients
    #input: vendor tag and body paragraph
    #output: send email to contractors and recipients
    def send
        # attachments['free_book.pdf'] = File.read('path/to/file.pdf')
        @contractor_emails = User.where(vendor: params[:vendor])
        @vendor_emails = User.where(vendor: params[:vendor],  role: admin)
        @body = params[:body]
        mail(to: @contractor, 
            bcc: @vendor_emails)
    end
end