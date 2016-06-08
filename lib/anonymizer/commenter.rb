module Anonymizer
  # Provides helper migration method to set a valid anonymizer comment.
  # Currently this only supports the follwing DB adapter types:
  #   postgres
  #
  # To support more implement aa private `execute_comment_<dialect>` method.
  module Commenter
    # Generates an anonymizer comment for the give table and column.
    # This is uses `reversible` so it should be safe to use within a `change`
    # style migration.
    #
    # @params [String] table to apply the comment
    # @params [String] column to apply the comment
    # @params [String] mutator strategy to apply
    def anonymize_comment(table, column, mutator)
      validate_mutator!(mutator)
      comment_updater.call(table: table, column: column, mutator: mutator)
    end

    private

    def validate_mutator!(mutator)
      Mutator.list.include?(mutator) or
        raise "Mutator #{mutator} is not valid. Try one of: #{Mutator.list}"
    end

    def comment_updater
      meth = "execute_comment_#{dialect}"
      if respond_to?(meth, true)
        method(meth)
      else
        raise NotImplementedError,
              "DB dialect `#{dialect}` not supported. Try one of: #{supported_dialects}"
      end
    end

    def execute_comment_postgresql(table:, column:, mutator:)
      reversible do |dir|
        dir.up do
          execute "COMMENT ON COLUMN #{table}.#{column} IS #{formatted_comment(mutator)};"
        end
        dir.down do
          execute "COMMENT ON COLUMN #{table}.#{column} IS NULL;"
        end
      end
    end

    def formatted_comment(mutator)
      escape_string("anon: #{mutator}")
    end

    def escape_string(text)
      connection.quote(text)
    end

    def supported_dialects
      methods.map { |m| m[/^execute_comment_(.*)$/, 1] }.compact
    end

    # TODO: There's got be a better way
    def dialect
      connection.adapter_name.downcase.to_s
    end
  end
end
