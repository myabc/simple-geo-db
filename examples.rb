# encoding: utf-8

require 'bundler'
Bundler.setup

require 'do_mysql'
require 'geo_db'

DataObjects::Mysql.logger = DataObjects::Logger.new(STDOUT, :debug)
at_exit { DataObjects.logger.flush }


munich_count = GeoDB::ZipCodeFinder.new.find_zip_codes(21179).size
berlin_count = GeoDB::ZipCodeFinder.new.find_zip_codes(14356).size

puts "Tut uns Leid Bayern, Berlin has #{berlin_count - munich_count} more PLZ than Munich!"

# Berlin Prenzlauer Berg
puts GeoDB::ZipCodeFinder.new.find_zip_codes(152597).join(',')

# Berlin Kreuzberg
puts GeoDB::ZipCodeFinder.new.find_zip_codes(152677).join(',')

# BERLIN
# puts get_location(14356)
# puts ZipCodeFinder.find_zip_codes(14356).join(',')
