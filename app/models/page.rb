class Page < ApplicationRecord
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

        EmailService.dispatch_email_helper(subject, content)
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
