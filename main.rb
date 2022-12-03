require_relative "backend.rb"
require_relative "frontend.rb"


def run_app()
    puts "Hello world"

    query = DataQuery.new
    query.pull_data("Pomona", 1234)
    
    Frontend.testing
end

run_app()