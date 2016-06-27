require 'anonymizer/text_block'

module Anonymizer
  module Postgres
    # Finds Postgres comment DML.
    class CommentBlock < TextBlock

      self.start_pattern = /^COMMENT ON COLUMN (?<table>[^\.]+)\.(?<column>\S+) IS '(?<comment>.*)';/
      self.end_pattern = /^$/

      def on_start_text(match, line)
        self.table = match[:table]
        parse_config(match)
      end

      def parse_config(match)
        # consolidate escaped single quotes
        comment = match[:comment].gsub("''", "'")
        data = YAML.load(comment).with_indifferent_access

        # give the config back to the delegate
        delegate.on_config(
          table: match[:table],
          column: match[:column],
          config: data[:anon]
        )
      end

      def parse(*)
        raise '`parse` should not be called to extract config from comments. ' \
             ' Try inspecting the PG dump format for changes. Comments are normally all in a single line.'
      end
    end
  end
end
