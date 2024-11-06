require "net/http"

# Usage: Scraper.new('https://www.google.com/finance/quote/USD-BRL?window=6M').text(selector: '.YMlKec.fxKbKc')

class Scraper
    attr_reader :document

    def initialize(url)
        response = Net::HTTP.get(URI(url))
        @document = Nokogiri::HTML(response)
    end

    def text(selector:)
        document.at_css(selector)&.text
    end

    def present?(selector:) 
        document.at_css(selector).present?
    end
end

# Initial Version Below

# Usage: Scraper.present?('https://www.google.com/finance/quote/USD-BRL?window=6M', '.YMlKec.fxKbKc')

# class Scraper
#     def self.document(url)
#         response = Net::HTTP.get(URI(url))
#         Nokogiri::HTML(response)
#     end

#     def self.text(url, selector)
#         document(url).at_css(selector).text
#     end

#     def self.present?(url, selector) 
#         document(url).at_css(selector).present?
#     end
# end