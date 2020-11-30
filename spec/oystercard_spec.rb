require 'oystercard'

describe Oystercard do

  it "Should be an instance of the Oystercard class" do
    expect(subject).to be_instance_of Oystercard
  end

  describe '#balance' do
    it "Checks if the new card has a 0 balance" do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'should add amount to balance' do
      expect{ subject.top_up(5) }.to change{ subject.balance }.by 5
    end

    it 'Throws an exception if balance limit is exceeded' do
      balance_limit = Oystercard::BALANCE_LIMIT
      subject.top_up(balance_limit)
      expect{ subject.top_up(1) }.to raise_error "Can't exceed the limit of £#{balance_limit}"
    end
  end
end
