require_relative './postgres/comment_block'
require_relative './postgres/copy_block'

module Anonymizer
  # Adapter to handle Postgres `pg_dump`
  module Postgres
    def self.text_blocks
      [CommentBlock, CopyBlock]
    end
  end
end
