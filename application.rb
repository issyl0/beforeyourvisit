require 'sinatra'
require 'shotgun'
require 'rest-client'
require 'titleize'

before do
  @countries_array = []
  @outgoing_tweet_hash = {}

  # Get the countries and populate @countries_array with each.
  countries = JSON.parse(RestClient.get("https://raw2.github.com/mledoze/countries/master/countries.json"))
  countries.each do |country|
    @countries_array.push(country["name"])
  end

  @countries_array.each do |country|
    # Find the FCO URLs for countries.
    find_fco_urls_for_countries(country)

    # Compose most of the tweet to send to a user (currently me).
    @outgoing_tweet_hash[country] = "@issyl0 You're going to #{country.titleize}! Have fun but please check travel advice and local customs: "
    # Take into account 140 - 25 characters for the t.co URL.
    if @outgoing_tweet_hash[country].length <= 115
      p @outgoing_tweet_hash[country].concat "#{@fco_url}."
    else
      # Could not construct tweet. Too many characters.
    end
  end
end

get '/' do
  erb :index
end

def find_fco_urls_for_countries(country)
  if country == "United States"
    country = "USA" # GOV.UK doesn't use "united-states" as the slug.
  end
 
  fco_url_base = "https://www.gov.uk/foreign-travel-advice/"
  # Convert the spaces in the country names to dashes.
  fco_url_country = country.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  @fco_url = fco_url_base + fco_url_country
end