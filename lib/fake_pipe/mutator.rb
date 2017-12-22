module FakePipe
  # This class handles mapping between a configured mutation such as
  # 'phone_number' and the logic to change the data.
  #
  # To create a new mutable named configuration create a method prefixed
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
    def list_with_comments
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
    def mutate_user_name(_)
      Faker::Internet.user_name
    end

    # Faker::Internet.url
    def mutate_url(_)
      Faker::Internet.url
    end

    # MD5 hash of cell contents
    def mutate_md5(cell)
      cell ? Digest::MD5.base64digest(cell) : cell
    end

    # Faker::Address.street_address
    def mutate_address_line_1(_)
      Faker::Address.street_address
    end

    # Faker::Address.secondary_address
    def mutate_address_line_2(_)
      Faker::Address.secondary_address
    end

    # Faker::Address.country
    def mutate_address_country(_)
      Faker::Address.country
    end

    # Faker::Address.city
    def mutate_address_city(_)
      Faker::Address.city
    end

    # Faker::Address.state
    def mutate_address_state(_)
      Faker::Address.state
    end

    # Faker::Address.postcode
    def mutate_address_postcode(_)
      Faker::Address.postcode
    end

    # Faker::Company.name
    def mutate_company_name(_)
      Faker::Company.name
    end

    # Faker::Company.catch_phrase
    def mutate_company_catch_phrase(_)
      Faker::Company.catch_phrase
    end

    # an empty curly brace '{}' - good for json object and array fields
    def mutate_empty_curly(_)
      '{}'
    end

    # an empty bracket '[]' - good for json::array objects
    def mutate_empty_bracket(_)
      '[]'
    end

    # an empty String
    def mutate_empty_string(_)
      ''
    end

    # Faker::Lorem.paragraph
    def mutate_lorem_paragraph(_)
      Faker::Lorem.paragraph
    end

    # Faker::Lorem.word
    def mutate_lorem_word(_)
      Faker::Lorem.word
    end

    # Faker::Lorem.sentence
    def mutate_lorem_sentence(_)
      Faker::Lorem.sentence
    end

    # Faker::Name.first_name
    def mutate_first_name(_)
      Faker::Name.first_name
    end

    # Faker::Name.last_name
    def mutate_last_name(_)
      Faker::Name.last_name
    end

    # Faker::Name.full_name
    def mutate_full_name(_)
      Faker::Name.name
    end

    # Faker::PhoneNumber.extension
    def mutate_phone_ext(_)
      Faker::PhoneNumber.extension
    end

    # bcrypt password as 'password'
    def mutate_bcrypt_password(_)
      '400$8$2d$f6ed5a490c441958$67f59aa61bc617849a3280b5e80f78607e53b5aa5807a44ddbc53e804e2e2a99'
    end

    # bcrypt salt used to generate password
    def mutate_bcrypt_salt(_)
      'au6lOASvp17AGsqkmE7'
    end

    ALPHABET = ('A'..'Z').to_a
    DIGITS = ('0'..'9').to_a
    # Six random uppercase letters followed by four random numbers - ex. 'ABCDEF1234'
    def mutate_ugcid(_)
      (ALPHABET.sample(6) + DIGITS.sample(4)).join
    end

    # UUID
    def mutate_uuid(_)
      SecureRandom.uuid
    end

    # Faker::Bank.name
    def mutate_bank_name(_)
      Faker::Bank.name
    end

    

    # Reopen class to define aliases on module_function
    class << self
      alias mutate_guid mutate_uuid
    end
  end
end
