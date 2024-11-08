class Page < ApplicationRecord
    include EmailHelper

    belongs_to :last_result, class_name: "Result", optional: true

    has_many :results
    validates :name, presence: true
    validates :url, presence: true
    validates :check_type, presence: true
    validates :selector, presence: true
    validates :match_text, presence: { if: ->{ check_type == 'text' }}

    def dispatch_email(result)
        subject = "Web Crawler: Last update of your page named #{result.page.name}"
        content = "The last result for your page #{result.page.name} was #{result.success ? 'SUCCESSFULL' : 'FAILURE'}!"

        from = SendGrid::Email.new(email: 'web-scrapper@guicarvalho.com.br')
        to = SendGrid::Email.new(email: 'guibrancopc@gmail.com')
        send_grid_content = SendGrid::Content.new(type: 'text/plain', value: content)

        mail = SendGrid::Mail.new(from, subject, to, send_grid_content)

        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])

        response = sg.client.mail._('send').post(request_body: mail.to_json)

        puts '&%&%&&%&%&%&%&%&&%&%&%&%&%&%&%&%&%&%&%&%&&%&%'
        puts response.status_code
        puts response.body
        # puts response.parsed_body
        puts response.headers
        puts '&%&%&&%&%&%&%&%&&%&%&%&%&%&%&%&%&%&%&%&%&&%&%'
    end

    def check_and_notify
        run_check
        dispatch_email(last_result)
    end

    def run_check
        scraper = Scraper.new(url)

        result = case check_type
                    when "text"
                        scraper.text(selector: selector)&.downcase == match_text.downcase
                    when "exists"
                        scraper.present?(selector: selector)
                    when "not_exist"
                        !scraper.present?(selector: selector)
                    end

        saved_result = results.create(success: result)
        update(last_result: saved_result)
    end
end
