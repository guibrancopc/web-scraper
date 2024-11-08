class EmailService
    def self.dispatch_email_helper(subject, content)
        from = 'web-scrapper@guicarvalho.com.br'
        to = 'guibrancopc@gmail.com'

        send_grid_from = SendGrid::Email.new(email: from)
        send_grid_to = SendGrid::Email.new(email: to)
        send_grid_content = SendGrid::Content.new(type: 'text/plain', value: content)

        mail = SendGrid::Mail.new(send_grid_from, subject, send_grid_to, send_grid_content)

        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])

        response = sg.client.mail._('send').post(request_body: mail.to_json)

        response
    end
end
