require 'data_objects'

module GeoDB
  module SQLFinder

    def with_connection
      connection = ::DataObjects::Connection.new('mysql://localhost:3306/opengeodb')
      yield(connection)
    ensure
      connection.close if connection
    end

    def execute_one_row_query(sql, *params)
      with_connection do |connection|
        command = connection.create_command(sql.gsub(/\s+/, ' ').strip)
        reader  = command.execute_reader(*params)
        return unless reader.next!
        values  = reader.values
        reader.close

        values.reverse
      end
    end

    DEFAULT_MAPPING = lambda { |row| row }
    def execute_query(sql, *params)
      mapping = params.last.is_a?(Proc) ? params.pop : DEFAULT_MAPPING

      with_connection do |connection|
        command = connection.create_command(sql.gsub(/\s+/, ' ').strip)
        reader  = command.execute_reader(*params)
        # this row is lazy - kick it
        values  = reader.map(&mapping)
        reader.close

        values
      end
    end

  end
end
