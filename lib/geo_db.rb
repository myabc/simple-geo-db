module GeoDB

  DEFAULT_COUNTRY = 'de'.freeze
  DEFAULT_CONFIG  = {
    'layer'      => 400200000,
    'locale'     => 'de',
    'countryLvl' => 'ld_lvl1',
    'countries'  => {
      'de'  => 105,
      'at'  => 106,
      'ch'  => 107
    }.freeze
  }.freeze

  # geodb_locations:
  LOCATIONS = {
    :continent            => 100100000,
    :state                => 100200000,
    :country              => 100300000, # Bundesland, Canton
    :regbezirk            => 100400000,
    :landkreis            => 100500000,
    :pol_division         => 100600000,
    :populated_area       => 100700000
  }.freeze

  # geodb_textdata
  TEXT_DATA = {
    :name                 => 500100000,
    :name_iso_3166        => 500100001,
    :name_7bitlc          => 500100002, # 7 Bit, Lower case
    :area_code            => 500300000,
    :kfz                  => 500500000,
    :ags                  => 500600000,
    :name_vg              => 500700000,
    :name_vg_7bitlc       => 500700001  # 7 Bit, Lower case
  }.freeze

end

require 'geo_db/city'
require 'geo_db/province'
require 'geo_db/sql_finder'
require 'geo_db/province_finder'
require 'geo_db/zip_code_finder'
