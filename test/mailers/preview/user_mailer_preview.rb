class UserMailerPreview < ActionMailer::Preview
    def send_contract_message
        puts 'vendor'
      UserMailer.with(body: params[:body], vendor: params[:vendor]).send_contract_message
    end
  end