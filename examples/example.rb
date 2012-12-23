#!/usr/bin/env ruby
require 'bundler'
Bundler.require
require 'geo_db'
require 'do_mysql'
require "sinatra/reloader" if development?

get '/plz/:plz' do
  @city, @province = GeoDB::ProvinceFinder.city_and_province_by_zip_code(params[:plz])
  not_found unless @city && @province

  slim :plz
end

not_found do
  'Page Not Found. Check your path or your PLZ / Zip Code'
end
