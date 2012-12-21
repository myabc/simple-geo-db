module GeoDB
  class ZipCodeFinder
    include GeoDB::SQLFinder

    def find_zip_codes(loc_id)
      mapping = lambda { |row| row['text_val'].to_i }
      execute_query(<<-SQL, loc_id, GeoDB::TEXT_DATA[:area_code], mapping)
        SELECT  geodb_textdata.loc_id,
                geodb_textdata.text_val
          FROM  geodb_textdata
          WHERE geodb_textdata.loc_id    = ?
            AND geodb_textdata.text_type = ?
      SQL
    end

  end
end
