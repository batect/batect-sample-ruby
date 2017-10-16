require 'securerandom'

RSpec.describe TransfersStore do
  subject { TransfersStore.new }

  describe 'creating and getting all transfers' do
    context 'after saving a transfer' do
      transfer = Transfer.new(SecureRandom.uuid, 'SEK', 'DKK', Date.new(2017, 10, 10), 100.20, 0.75)

      before(:each) do
        subject.save_transfer transfer
      end

      it 'returns the newly-saved transfer in the list of transfers' do
        expect(subject.load_all_transfers).to eq [transfer]
      end
    end
  end
end
