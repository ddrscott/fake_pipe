require 'spec_helper'

module Anonymizer
  describe Piper do
    let(:outputter) { StringIO.new }

    context 'Emails' do
      let(:sql) {<<-SQL
COMMENT ON COLUMN users.email IS 'anon: email';

COPY users (id, email) FROM stdin;
0	a@example.com
1	b@example.com
\.
                 SQL
      }
      let(:faked_sql) {<<-SQL
COMMENT ON COLUMN users.email IS 'anon: email';

COPY users (id, email) FROM stdin;
0	foo@faked.com
1	foo@faked.com
\.
      SQL
      }
      before do
        allow(Mutator).to receive(:mutate_email).and_return("foo@faked.com")
      end
      it 'handles email' do
        output = StringIO.new
        instance = described_class.new(io: StringIO.new(sql), outputter: output, adapter: 'postgres')
        instance.run
        output.rewind
        expect(output.read).to eq(faked_sql)
      end
    end
  end
end
