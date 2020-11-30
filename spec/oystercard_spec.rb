require 'oystercard'

describe Oystercard do
  card = Oystercard.new
  it "Should be an instance of the Oystercard class" do
    expect(card).to be_instance_of Oystercard
  end

  describe '#balance' do
    it "Checks if the new card has a 0 balance" do
      expect(card.balance).to eq 0
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'should add amount to balance' do
      expect{ card.top_up(5) }.to change{ card.balance }.by 5
    end
  end
end
