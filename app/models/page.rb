class Page < ApplicationRecord
    belongs_to :last_result, class_name: "Result"

    has_many :results
    validates :name, presence: true
    validates :url, presence: true
    validates :check_type, presence: true
    validates :selector, presence: true
    validates :match_text, presence: { if: ->{ check_type == 'text' }}

    def run_check!
        scraper = Scraper.new(url)

        result = case check_type
                    when "text"
                        scraper.text(selector: selector).downcase == match_text.downcase
                    when "exists"
                        scraper.present?(selector: selector)
                    when "not_exist"
                        !scraper.present?(selector: selector)
                    end

        saved_result = results.create(success: result)
        update(last_result: saved_result)
    end
end
