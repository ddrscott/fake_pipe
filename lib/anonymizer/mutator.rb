module Anonymizer
  # This class handles mapping between a configured mutation such as
  # 'phone_number' and the logic to change the data.
  #
  # To create a new mutable nameed configuration create a method prefixed
  # with `mutate_`. The method will receive the original cell value and is
  # expected to return the mutated value. Please add comment to the mutate
  # method. The comment is used by `rake methods` to get a listing of all
  # possible mutations.
  module Mutator
    module_function

    def mutate(name, cell)
      mutator_method = "mutate_#{name}"
      if respond_to? mutator_method
        __send__(mutator_method, cell)
      else
        raise "Mutator named `#{name}` not found. Try one of these: #{list.join(', ')}"
      end
    end

    def list
      @list ||= public_methods
                .map { |m| m.to_s[/^mutate_(\w+)$/, 1] }
                .select(&:present?)
                .sort
    end

    # Utility method for outputting available mutators.
    # Only require method source here.
    # Currently used by a `rake methods`.
    def list_with_commnets
      require 'method_source'
      list.map { |short| [short, public_method("mutate_#{short}").comment.strip] }
    end

    def clean_phone
      Faker::PhoneNumber.phone_number.gsub(/\D|(^1)/, '')[0, 10]
    end

    # Faker::PhoneNumber with digits only
    def mutate_phone_number(_cell)
      clean_phone
    end

    # Faker email
    def mutate_email(_cell)
      Faker::Internet.email
    end

    # MD5 hash of cell contents
    def mutate_md5(cell)
      cell ? Digest::MD5.base64digest(cell) : cell
    end
  end
end
