require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'List supported FakePipe methods'
task :methods do
  require 'fake_pipe'
  methods = FakePipe::Mutator.list_with_comments
  longest_name = methods.map(&:first).max_by(&:size)
  puts methods.map { |m, c| "anon: #{m.ljust(longest_name.size)}  #{c}" }
end
