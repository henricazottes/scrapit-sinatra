require 'sinatra'
require 'sinatra/json'
require 'nokogiri'
require 'open-uri'
require 'rest-client'
require 'spicy-proton'

BASE_URL = ENV['BASE_URL']

get '/' do
	haml :index
end

get '/scraps/new' do
	random_name = Spicy::Proton.pair
	haml :'scraps/edit', locals: {name: random_name}
end

get '/scraps/:id/edit' do
	haml :'scraps/edit', {id: id}
end

get '/scraps/:id' do
	
end

get '/api' do
	content_type :'application/json'
	decoded = CGI.unescape(params['scraps'])
	scraps = JSON.parse decoded
	obj = {}
	# Fetch and parse HTML document
	scraps.each do |name, selector, url|
		doc = Nokogiri::HTML(RestClient.get(url))
		obj[name] = doc.css(selector).map { |e| e.text.strip }
	end
	json obj
end

