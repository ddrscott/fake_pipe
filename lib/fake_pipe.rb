# external gems
require 'faker'
require 'active_support/all'
require 'csv'
require 'yaml'

# internal
require 'fake_pipe/version'
require 'fake_pipe/text_block'
require 'fake_pipe/any_block'
require 'fake_pipe/piper'
require 'fake_pipe/mutator'

module FakePipe
  module_function

  def pipe(io:, outputter: $stdout, adapter: 'postgres')
    piper = FakePipe::Piper.new(io: io, outputter: outputter, adapter: adapter)
    piper.run
  end
end
