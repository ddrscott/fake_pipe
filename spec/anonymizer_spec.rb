require 'spec_helper'

module Anonymizer
  describe Piper do
    let(:outputter) { StringIO.new }
    it 'does something useful' do
      File.open('spec/sample-pg-dump.sql', 'r') do |f|
        parser = described_class.new(io: f, outputter: outputter, handlers: [CopyHandler])
        result = parser.parse
        expect(parser.comments).to eq('auth_users' => {
                                        'phone' => 'phone_number',
                                        'email' => 'email',
                                        'agency_id' => 'md5'
                                      })
      end
    end
  end
end
