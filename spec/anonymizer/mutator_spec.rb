require 'spec_helper'

module Anonymizer
  describe Mutator do
    context 'happy path' do
      it 'lists mutators' do
        expect(described_class.list)
          .to contain_exactly("address_city", "address_country", "address_line_1", "address_line_2", "address_postcode", "address_state", "bcrypt_password", "bcrypt_salt", "clean_phone_number", "company_catch_phrase", "company_name", "email", "empty_string", "first_name", "full_name", "last_name", "lorem_paragraph", "lorem_sentence", "lorem_word", "md5", "phone_ext", "phone_number", "url", "user_name", "uuid")
      end
    end

    context 'sad path' do
      it 'provides reasonable error message' do
        expect { described_class.mutate('i_dont_exist', 'dont_care') }
          .to raise_error(/#{described_class.list.join(', ')}/)
      end
    end
  end
end
