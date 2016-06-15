module Anonymizer
  # Catch all text block.
  # Generic base state while a more interesting text block is not present.
  class AnyBlock
    include TextBlock
   
    def start_text?(line)
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
