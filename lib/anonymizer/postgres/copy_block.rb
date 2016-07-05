require 'anonymizer/text_block'

module Anonymizer
  module Postgres
    # Finds COPY... text blocks inside of `pg_dumps`
    class CopyBlock < TextBlock

      DELIMITER = "\t"

      COLUMN_SPLITTER = /,\s*/

      self.start_pattern = /^COPY (?<table>\S+) \((?<columns>[^)]*)\) FROM stdin;/
      self.end_pattern = /^\\\.$/

      # @return [Hash<Integer,String>] Index for column ordinal and column name: { 1 => column_name }
      def on_start_text(match, line)
        @table = match[:table]
        @columns = match[:columns].split(COLUMN_SPLITTER)
        @column_idx = Hash[@columns.map.with_index { |name, i| [i, name] }]
      end

      # Postgres COPY format is NOT CSV.
      # >  https://www.postgresql.org/docs/9.1/static/sql-copy.html
      #
      # @return [String] maybe mutated by `delegate.on_cell`
      def parse(line)
        row = line.split(DELIMITER)
        faked = row.map.with_index do |cell, i|
          delegate.on_cell(table: @table, column: @column_idx[i], cell: cell)
        end
        faked.join(DELIMITER)
      end
    end
  end
end
