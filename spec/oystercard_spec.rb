require 'oystercard'

describe Oystercard do
  let(:journey) { Journey.new }
  let(:oystercard) { Oystercard.new }

  shared_context 'fully topped up oystercard' do
    before do
      @balance_limit = Oystercard::BALANCE_LIMIT
      subject.top_up(@balance_limit)
    end
  end

  shared_context 'oystercard already in journey' do
    before do
      journey.touch_in(entry_station, oystercard)
    end
  end

  it 'Should be an instance of the Oystercard class' do
    expect(subject).to be_instance_of Oystercard
  end

  describe '#balance' do
    it 'Checks if the new card has a 0 balance' do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'should add amount to balance' do
      expect { subject.top_up(5) }.to change { subject.balance }.by 5
    end
  end

  describe '#top_up with full card' do
    include_context 'fully topped up oystercard'

    it 'Throws an exception if balance limit is exceeded' do
      expect { subject.top_up(1) }.to raise_error "Can't exceed the limit of £#{@balance_limit}"
    end
  end

  describe '#deduct' do
    include_context 'fully topped up oystercard'
    
    it 'should deduct amount from balance' do
      expect { subject.deduct(5) }.to change { subject.balance }.by(-5)
    end
  end
end
