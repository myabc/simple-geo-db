module GeoDB

  # Based on http://opengeodb.org/wiki/OpenGeoClassByChristianFigge
  class ProvinceFinder
    include GeoDB::SQLFinder

    attr_reader :country
    attr_reader :country_id

    def initialize(country = 'de')
      @country     = country
      @country_id  = GeoDB::DEFAULT_CONFIG['countries'].fetch(@country)
    end

    def self.province_by_zip_code(zip_code)
      new.province_by_zip_code(zip_code)
    end

    def self.city_by_zip_code(zip_code)
      new.city_by_zip_code(zip_code)
    end

    def self.city_and_province_by_zip_code(zip_code)
      new.city_and_province_by_zip_code(zip_code)
    end

    def self.all_provinces
      new.all_provinces
    end

    def province_by_zip_code(zip_code)
      text_type   = GeoDB::TEXT_DATA[:name]
      zip_id      = GeoDB::TEXT_DATA[:area_code]
      province_id = GeoDB::TEXT_DATA[:country]

      with_connection do |connection|
        command    = connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip)
        SELECT geodb_textdata.loc_id, geodb_textdata.text_val FROM geodb_textdata
          WHERE  geodb_textdata.loc_id = (
            SELECT geodb_hierarchies.id_lvl3
            FROM   geodb_hierarchies, geodb_textdata
              WHERE geodb_hierarchies.id_lvl2 = ?
                AND geodb_textdata.text_type = ?
                AND geodb_textdata.text_val = ?
                AND geodb_textdata.loc_id = geodb_hierarchies.loc_id
                LIMIT 1
            )
            AND geodb_textdata.text_type = ?
        SQL
        reader = command.execute_reader(country_id, zip_id, zip_code, text_type)
        return unless reader.next!
        values = reader.values
        reader.close

        Province.new(*values.reverse)
      end
    end

    def city_by_zip_code(zip_code)
      text_type   = GeoDB::TEXT_DATA[:name]
      layer       = GeoDB::DEFAULT_CONFIG['layer']
      zip_id      = GeoDB::TEXT_DATA[:area_code]
      locale      = GeoDB::DEFAULT_CONFIG['locale']

      with_connection do |connection|
        command    = connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip)
        SELECT geodb_textdata.loc_id, geodb_textdata.text_val FROM geodb_textdata WHERE loc_id = (
          SELECT geodb_textdata.loc_id FROM geodb_textdata
            WHERE  geodb_textdata.loc_id = (
              SELECT MIN(geodb_textdata.loc_id)
              FROM geodb_hierarchies, geodb_textdata
                WHERE geodb_hierarchies.id_lvl2 = ?
                  AND geodb_textdata.text_type = ?
                  AND geodb_textdata.text_val = ?
                  AND geodb_textdata.loc_id = geodb_hierarchies.loc_id
            )
              AND geodb_textdata.text_type = ?
              LIMIT 1
          )
          AND geodb_textdata.text_type = ?
          AND geodb_textdata.text_locale = ?
        SQL
        reader = command.execute_reader(country_id, zip_id, zip_code, layer, text_type, locale)
        return unless reader.next!
        values = reader.values
        reader.close

        City.new(*values.reverse)
      end
    end

    def city_and_province_by_zip_code(zip_code)
      city_province_pair = [city_by_zip_code(zip_code), province_by_zip_code(zip_code)]
      return nil if city_province_pair.none?
      city_province_pair
    end

    def all_provinces
      text_type   = GeoDB::TEXT_DATA[:name]

      with_connection do |connection|
        command    = connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip)
        SELECT DISTINCT geodb_textdata.loc_id, geodb_textdata.text_val
        FROM geodb_locations, geodb_hierarchies, geodb_textdata
        WHERE geodb_locations.loc_type = #{GeoDB::LOCATIONS[:country]}
          AND geodb_locations.loc_id = geodb_hierarchies.id_lvl3
          AND geodb_locations.loc_id = geodb_textdata.loc_id
          AND geodb_textdata.text_type  = ?
          AND geodb_hierarchies.id_lvl2 = ?
        SQL
        reader = command.execute_reader(text_type, country_id)
        reader.map do |row|
          Province.new(*row.values_at('text_val', 'loc_id'))
        end
      end
    end

  end
end
