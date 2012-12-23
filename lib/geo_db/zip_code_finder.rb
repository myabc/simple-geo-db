module GeoDB
  class ZipCodeFinder
    include GeoDB::SQLFinder

    attr_reader :country
    attr_reader :country_id

    def initialize(country = GeoDB::DEFAULT_COUNTRY)
      @country     = country
      @country_id  = GeoDB::DEFAULT_CONFIG['countries'].fetch(@country)
    end

    def find_zip_codes(loc_id)
      mapping = lambda { |row| row['text_val'].to_i }
      sql     = build_sql("geodb_textdata.loc_id = ?")
      execute_query(sql, loc_id, GeoDB::TEXT_DATA[:area_code], mapping)
    end

    # @note a very slow and expensive query
    def find_zip_codes_by_name(name)
      mapping = lambda { |row| row['text_val'].to_i }
      sql     = build_sql("geodb_textdata.loc_id IN (#{HIERARCHY_SQL})")
      results = execute_query(sql, country_id, GeoDB::TEXT_DATA[:name],
        "%#{name}%", GeoDB::TEXT_DATA[:area_code], mapping)
    end

    private

    HIERARCHY_SQL = <<-SQL.freeze
      SELECT  geodb_textdata.loc_id
        FROM  geodb_hierarchies, geodb_textdata
        WHERE geodb_hierarchies.id_lvl2 = ?
          AND geodb_textdata.text_type  = ?
          AND geodb_textdata.text_val   LIKE ?
          AND geodb_textdata.loc_id     = geodb_hierarchies.loc_id
    SQL

    def build_sql(conditions_sql)
      <<-SQL
      SELECT  geodb_textdata.loc_id,
              geodb_textdata.text_val
        FROM  geodb_textdata
        WHERE #{conditions_sql}
          AND geodb_textdata.text_type = ?
      SQL
    end

  end
end
