require_relative "backend.rb"
require_relative "frontend.rb"
# require_relative "index.html.erb"

def run_app()
    query = DataQuery.new
    query.pull_data("Pomona", date)

    puts query.get_date
    puts query.get_desc
    puts query.get_max
    puts query.get_min
    # puts index.html.erb.date
    Frontend.testing
end

run_app()