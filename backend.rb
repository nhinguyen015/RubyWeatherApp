require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class DataQuery
    def initialize()
        file = File.open("APIKEY.txt")
        @key = file.read
    end

    def pull_data(location, date)
        begin  # "try" block
            url = URI("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"+location+"?key="+@key)

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Get.new(url)

            response = http.request(request)
            body = response.read_body
        
            result = JSON.parse(body)

            result["days"].each do |days|
                weather_date = days["datetime"]
                weather_desc = days["description"]
                weather_tmax = days["tempmax"]
                weather_tmin = days["tempmin"]
         
                puts "Forecast for date: #{weather_date}"
                puts " General conditions: #{weather_desc}"
                puts " The high temperature will be #{weather_tmax}"
                puts " The low temperature will be #{weather_tmin}"
            end
        rescue # optionally: `rescue Exception => ex`
            puts "error occured during query"
        ensure # will always get executed
            #puts 'Always gets executed.'
        end 
    end
end