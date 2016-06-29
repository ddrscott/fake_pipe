module Anonymizer
  # Catch all text block.
  # Generic base state while a more interesting text block is not present.
  class AnyBlock < TextBlock
  
    def match_start_text(line)
      true
    end

    def start_text?
      true
    end

    def end_text?(line)
      true
    end

    def parse(line)
      line
    end
  end
end
