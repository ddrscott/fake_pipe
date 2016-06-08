require 'anonymizer/text_block'

module Anonymizer
  module Postgres

    # Finds COPY... text blocks inside of `pg_dumps`
    class CopyBlock
      include TextBlock

      CSV_OPTIONS = {
        col_sep: "\t"
      }

      COLUMN_SPLITTER = /,\s*/

      self.start_pattern = /^COPY (?<table>\S+) \((?<columns>[^)]*)\) FROM stdin;/
      self.end_pattern = /\\\\./

      # When theres a match save out all the table/column information 
      def start_text?(line)
        super.try(:tap) do |match|
          build_column_index(match: match, line: line)
        end
      end

      # @return [Hash<Integer,String>] Index for column ordinal and column name: { 1 => column_name }
      def build_column_index(match:, line:)
        @table = match[:table]
        @columns = match[:columns].split(COLUMN_SPLITTER)
        @column_idx = Hash[@columns.map.with_index{|name, i| [i, name]}]
      end

      # @return [String] maybe mutated by `delegate.on_cell`
      def parse(line)
        row = CSV.parse(line, CSV_OPTIONS).first
        faked = row.map.with_index do |cell, i|
          delegate.on_cell(table: @table, column: @column_idx[i], cell: cell)
        end
        CSV.generate_line(faked, CSV_OPTIONS)
      end
    end
  end
end
