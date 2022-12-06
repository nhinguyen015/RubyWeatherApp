require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class DataQuery
    def initialize()
        #file = File.open("APIKEY.txt")
        @key = "M4TY4973SRXVGEK575KCRFQ6Q"
        @date = ""
        @desc = ""
        @max_temp = ""
        @min_temp = ""
        @location = ""
    end

    def pull_data(location, date)
        @location = location
        puts date
        dateStr = date.split("/")
        correctDate = dateStr[2] + "-" + dateStr[1] + "-" + dateStr[0]

        entries = {}

        begin  # "try" block
            url = URI("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"+location+"/"+correctDate+"/"+"?key="+@key)

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
            writeToCSV("weather"+location+".csv", entries)

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

    def get_city()
        return @location
    end

    def writeToCSV(fileName, data)

        pokemonURL  =   {"Piplup" => "https://static.pokemonpets.com/images/monsters-images-800-800/393-Piplup.webp",
                        "Blastoise" => "https://assets.pokemon.com/assets/cms2/img/pokedex/full/009_f2.png",
                        "Charizard" => "https://static.wikia.nocookie.net/monster/images/9/95/Charizard.png/revision/latest?cb=20170708221247",
                        "Charmander" => "https://clipart.info/images/ccovers/1528080673Charmander-pokemon-png.png",
                        "Squirtle" => "https://i.pinimg.com/originals/68/ea/e5/68eae5110003466af047764ff88e2403.png",
                        "Snom" => "https://th.bing.com/th/id/OIP.5E9-U1ylYqCwCI2_8s8-7AAAAA?pid=ImgDet&rs=1",
                        "Abomasnow" => "https://cdn.discordapp.com/attachments/1014300724152246385/1049568987329081344/460-Abomasnow.png" 
                        }

        File.open(fileName, 'w') do |file|
            file.write("Date,Description,Max Temp,Min Temp, Pokemon, Pokemon Code")
            file.write("\n")
            for map in data

                desc = map[1][0]
                max_temp = map[1][1]
                min_temp = map[1][2]
                pokeCode = ""

                
                if desc.include? "Rain" or (desc.include? "rain" and desc.include? "chance")
                    pokemon = "Piplup"
                elsif desc.include? "Rain" or desc.include? "rain"
                    pokemon = "Blastoise"
                elsif (max_temp > 90)
                    pokemon = "Charizard"  
                elsif (max_temp > 80)
                    pokemon = "Charmander"
                elsif (max_temp > 70)
                    pokemon = "Squirtle"
                elsif (max_temp > 55)
                    pokemon = "Snom"
                else
                    pokemon = "Abomasnow"
                end
                 
                file.write(map[0], ",", desc, ",", max_temp, ",", min_temp, ",", pokemon, ", ", pokemonURL[pokemon])
                file.write("\n")
            end
        end
    end
end