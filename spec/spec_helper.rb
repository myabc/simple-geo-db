require 'bundler'
Bundler.setup

require 'do_mysql'
require 'geo_db'

DataObjects::Mysql.logger = DataObjects::Logger.new('log/do.log', :debug)
at_exit { DataObjects.logger.flush }
