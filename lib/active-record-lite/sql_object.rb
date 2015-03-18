require_relative 'associatable'
require_relative 'searchable'
require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  extend Searchable
  extend Associatable

  def self.columns
    data = DBConnection.execute_with_columns(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    data.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |column|
      define_method("#{column}") do
        self.attributes[column]
      end
      define_method("#{column}=") do |value|
        self.attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
    data = DBConnection.execute(<<-SQL)
      SELECT
      #{table_name}.*
      FROM
        #{table_name}
    SQL
    parse_all(data)
  end

  def self.parse_all(results)
    results.map do |params|
      self.new(params)
    end
  end

  def self.find(id)
    data = DBConnection.execute(<<-SQL, id)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL
    (data.empty?) ? nil : self.new(data.first)
  end

  def initialize(params = {})
    params.each do |key, value|
      begin
        send("#{key}=", value)
      rescue NoMethodError
        raise "unknown attribute '#{key}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |column| send(column) }
  end

  def insert
    columns = self.class.columns
    question_marks = ["?"] * columns.length
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{columns.join(', ')})
      VALUES
        (#{question_marks.join(', ')})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    setters = self.class.columns.map { |column| "#{column} = ?" }
    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{setters.join(', ')}
      WHERE
        id = ?
    SQL
  end

  def save
    (id.nil?) ? insert : update
  end
end
