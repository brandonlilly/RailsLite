module Searchable
  def where(params)
    clauses = params.keys.map { |column| "#{column} = ?" }
    # debugger
    data = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{clauses.join(' AND ')}
    SQL
    parse_all(data)
  end
end
