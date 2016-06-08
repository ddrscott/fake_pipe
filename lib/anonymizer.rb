# external gems
require 'faker'
require 'active_support/all'
require 'csv'
require 'yaml'

# internal
require 'anonymizer/version'
require 'anonymizer/text_block'
require 'anonymizer/piper'
require 'anonymizer/mutator'

module Anonymizer
  module_function

  def pipe(io:, outputter: $stdout, adapter: 'postgres')
    piper = Anonymizer::Piper.new(io: io, outputter: outputter, adapter: adapter)
    piper.run
  end
end
