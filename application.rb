require 'sinatra'
require 'shotgun'
require 'rest-client'

before do
  @countries_array = []

  # Get the countries and populate @countries_array with each.
  countries = JSON.parse(RestClient.get("https://raw2.github.com/mledoze/countries/master/countries.json"))
  countries.each do |country|
    @countries_array.push(country["name"])
  end
end

get '/' do
  erb :index
end