require_relative "demo_app/backend.rb"
require_relative "frontend.rb"


def run_app()
    query = DataQuery.new
    query.pull_data("Pomona", 1234)

    puts query.get_date
    puts query.get_desc
    puts query.get_max
    puts query.get_min
    
    Frontend.testing
end

run_app()