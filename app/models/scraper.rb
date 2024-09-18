require "net/http"

class Scraper
   def self.text(url)
    response = Net::HTTP.get(URI(url))
   end 
end