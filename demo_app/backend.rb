require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class DataQuery
    def initialize()
        file = File.open("APIKEY.txt")
        @key = "M4TY4973SRXVGEK575KCRFQ6Q"
        @date = ""
        @desc = ""
        @max_temp = ""
        @min_temp = ""
    end

    def pull_data(location, date)

        entries = {}

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

                entries[weather_date] = [weather_desc, weather_tmax, weather_tmin]
                
                @date = weather_date
                @desc = weather_desc
                @max_temp = weather_tmax
                @min_temp = weather_tmin
            end
            writeToCSV("weather.csv", entries)

        rescue # optionally: `rescue Exception => ex`
            puts "error occured during query"
        ensure # will always get executed
            #puts 'Always gets executed.'
        end
    end

    def get_date()
        return @date
    end

    def get_desc()
        return @desc
    end

    def get_max()
        return @max_temp
    end

    def get_min()
        return @min_temp
    end

    def writeToCSV(fileName, data)
        File.open(fileName, 'w') do |file|
            file.write("Date,Description,Max Temp,Min Temp, Pokemon Code")
            file.write("\n")
            for map in data

                desc = map[1][0]
                max_temp = map[1][1]
                min_temp = map[1][2]
                pokeCode = ""

                
                if desc.include? "Rain" or (desc.include? "rain" and desc.include? "chance")
                    pokeCode = "Piplup"
                elsif desc.include? "Rain" or desc.include? "rain"
                    pokeCode = "Blastoise"
                elsif (max_temp > 90)
                    pokeCode = "Charizard"  
                elsif (max_temp > 80)
                    pokeCode = "Charmander"
                elsif (max_temp > 70)
                    pokeCode = "Squirtle"
                elsif (max_temp > 55)
                    pokeCode = "Snom"
                else
                    pokeCode = "Abomasnow"
                end
                 
                file.write(map[0], ",", desc, ",", max_temp, ",", min_temp, ",", pokeCode)
                file.write("\n")
            end
        end
    end
end