require "sinatra"
require "haml"
require "nokogiri"
require "open-uri"

require "pp"

# !.8.6 compat
class Array
  def sample(n)
    r = []
    while r.size<n
      r << rand(size)
      r.uniq!
    end
    
    r.map {|i| self[i]}
  end
end

class TS
  class << self
    CACHE_FILE = "/tmp/cache.html"
    DATA_URL = "http://kefirnet.ath.cx/sygnaly/?pokaz"
    def sample(n)
      # @doc.css("div.question").to_a.select{|e| e.to_s =~ /q819/}.map do |q|
      doc.css("div.question").to_a.sample(n).map do |q|
        q.css("input[type=text]").each {|o|
          o["rel"] = o["value"]
          o.remove_attribute("value")
          o.remove_attribute("disabled")
        }
        
        q.css("option[selected='1']").each {|o|
          o["class"] = "correct"
          o.remove_attribute("selected")
          o.content = o.text.sub(/^\*/, '')
        }
        
        q.css("input[type=checkbox]").each {|c| 
          x = c["checked"] == "1"
          c.remove_attribute("checked")
          c.remove_attribute("disabled") 
          c.parent["class"] = "#{c.parent["class"]} correct" if x
        }
        q.to_html
      end.join
    end
  
    def doc
      @doc ||= Nokogiri::HTML(fetch)
    end
  
    def fetch
      begin
        puts "Checking #{CACHE_FILE}..."
        data = File.read(CACHE_FILE)
        puts "Using cache file"
      rescue
        puts "Cache not found. Loading #{DATA_URL}..."
        data = open(DATA_URL).read
        File.open(CACHE_FILE, "w"){|f| f.write @data }
      end
      
      data
    end
  end
end

get "/" do
  @questions = TS.sample(10)
  haml :index
end

if __FILE__ == $0
  TS.sample(1)
end