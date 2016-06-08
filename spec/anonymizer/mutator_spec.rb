require 'spec_helper'

module Anonymizer
  describe Mutator do
    context 'happy path' do
      it 'lists mutators' do
        expect(described_class.list)
          .to contain_exactly(*%w(phone_number email md5))
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
