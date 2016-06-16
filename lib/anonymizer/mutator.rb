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
        public_send(mutator_method, cell)
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

    # Faker::PhoneNumber with punctuation and extensions
    def mutate_phone_number(_)
      Faker::PhoneNumber.phone_number
    end

    # Faker::PhoneNumber 10-digits only
    def mutate_clean_phone_number(_)
      Faker::PhoneNumber.phone_number.gsub(/\D|(^1)/, '')[0, 10]
    end

    # Faker email
    def mutate_email(_)
      Faker::Internet.email
    end

    # Faker::Internet.user_name
    def mutate_user_name
      Faker::Internet.user_name
    end

    # Faker::Internet.url
    def mutate_url
      Faker::Internet.url
    end

    # MD5 hash of cell contents
    def mutate_md5(cell)
      cell ? Digest::MD5.base64digest(cell) : cell
    end

    # Faker::Address.street_address
    def mutate_address_line_1
      Faker::Address.street_address
    end

    # Faker::Address.secondary_address
    def mutate_address_line_2
      Faker::Address.secondary_address
    end

    # Faker::Address.country
    def mutate_address_country
      Faker::Address.country
    end

    # Faker::Address.city
    def mutate_address_city
      Faker::Address.city
    end

    # Faker::Address.state
    def mutate_address_state
      Faker::Address.state
    end

    # Faker::Address.postcode
    def mutate_address_postcode
      Faker::Address.postcode
    end

    # Faker::Company.name
    def mutate_company_name
      Faker::Company.name
    end

    # Faker::Company.catch_phrase
    def mutate_company_catch_phrase
      Faker::Company.catch_phrase
    end

    # an empty String
    def mutate_empty_string
      ''
    end

    # Faker::Lorem.paragraph
    def mutate_lorem_paragraph
      Faker::Lorem.paragraph
    end

    # Faker::Lorem.word
    def mutate_lorem_word
      Faker::Lorem.word
    end

    # Faker::Lorem.sentence
    def mutate_lorem_sentence
      Faker::Lorem.sentence
    end

    # Faker::Name.first_name
    def mutate_first_name
      Faker::Name.first_name
    end

    # Faker::Name.last_name
    def mutate_last_name
      Faker::Name.last_name
    end

    # Faker::Name.full_name
    def mutate_full_name
      Faker::Name.full_name
    end

    # Faker::PhoneNumber.extension
    def mutate_phone_ext
      Faker::PhoneNumber.extension
    end

    # TODO don't know how to do this, yet
    def mutate_password
      'abracadabra'
    end

    # GUID/UUID
    def mutate_uuid
      SecureRandom.uuid
    end
    alias mutate_guid mutate_uuid

  end
end
