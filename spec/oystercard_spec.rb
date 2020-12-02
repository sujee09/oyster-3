require 'oystercard'

describe Oystercard do
  shared_context 'fully topped up oystercard' do
    before do
      @balance_limit = Oystercard::BALANCE_LIMIT
      subject.top_up(@balance_limit)
    end
  end

  shared_context 'oystercard already in journey' do
    before do
      subject.touch_in(entry_station)
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
    it 'should deduct amount from balance' do
      subject.top_up(20)
      expect { subject.deduct(5) }.to change { subject.balance }.by(-5)
    end
  end

  describe '#in_journey?' do
    it 'is initially not in a journey' do
      expect(subject).not_to be_in_journey
    end
  end

  describe '#touch_in' do
    include_context 'fully topped up oystercard'
    include_context 'oystercard already in journey'
    let(:entry_station) { double :station }
    it 'can touch in' do
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end
  end

  describe '#touch_in' do
    let(:entry_station) { double :station }
    it 'Cant be used if it doesnt have atleast £1' do
      expect { subject.touch_in(entry_station) }.to raise_error 'Have insufficient funds'
    end

    it 'Should allow to touch in' do
      subject.top_up(5)
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end

    it 'has an empty list of journeys by default' do
      expect(subject.journeys).to be_empty
    end
  end

  describe '#touch_out' do
    let(:entry_station) { double :station }
    let(:exit_station) { double :station }
    it 'can touch out' do
      subject.top_up(50)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end

    it 'stores the exit station' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.exit_station).to eq(exit_station)
    end

    it 'deducts fare when touch_out' do
      minimum_fare = Oystercard::MINIMUM_FARE
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-minimum_fare)
    end
  end

  describe '#entry_station' do
    let(:entry_station) { double :station }
    it 'stores the entry station' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject.entry_station).to eq entry_station
    end
  end

  describe '#method' do
    let(:journey){ {entry_station: entry_station, exit_station: exit_station} }
    it 'stores a journey' do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys).to include journey
    end
  end

end
