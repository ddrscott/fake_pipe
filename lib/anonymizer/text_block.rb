module Anonymizer
  # Blocks are considered between the #start_text? and #end_text?
  # Any lines in between the start and end are passed to #parse
  #
  # @start_match is available in case there's information in there #parse could
  # find interesting.
  class TextBlock

    class_attribute :start_pattern
    class_attribute :end_pattern

    attr_accessor :delegate, :start_match, :table

    def initialize(delegate)
      self.delegate = delegate
    end

    def start_text?(line)
      start_pattern && (self.start_match = start_pattern.match(line))
    end

    def end_text?(line)
      end_pattern && end_pattern.match(line)
    end

    def parse(_line)
      raise NotImplementedError, "#{self} doesn't implement `parse`."
    end
  end
end
