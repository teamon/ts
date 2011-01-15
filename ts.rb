require "sinatra"
require "haml"
require "nokogiri"
require "open-uri"

require "pp"

class TS
  class << self
    CACHE_FILE = "/tmp/cache.html"
    DATA_URL = "http://kefirnet.ath.cx/sygnaly/?pokaz"
    def sample(n)
      load
      @doc = Nokogiri::HTML(@data)
      
      pp @doc.css("div.question").to_a.sample(n).map {|q0|
        {
          :text => q0.css("div.questionText").text.strip,
          :answers => q0.css("ul li").map {|q1|
            {
              :text => q1.text.strip,
              :correct => !!q1.css("input").attr("checked")
            }
          }
        }
      }
    end
  
  
    def load
      puts "Checking #{CACHE_FILE}..."
      @data = File.read(CACHE_FILE)
      puts "Using cache file"
    rescue
      puts "Cache not found. Loading #{DATA_URL}..."
      @data = open(DATA_URL).read
      File.open(CACHE_FILE, "w"){|f| f.write @data }
    end
  end
end

get "/" do
  @questions = TS.sample(10)
  haml :index
end