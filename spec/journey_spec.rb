require 'journey'

describe Journey do
  let(:journey){ Journey.new }
  let(:oystercard){ Oystercard.new }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  shared_context 'fully topped up oystercard' do
    before do
      @balance_limit = Oystercard::BALANCE_LIMIT
      oystercard.top_up(@balance_limit)
    end
  end

  shared_context 'oystercard already in journey' do
    before do
      journey.touch_in(entry_station, oystercard)
    end
  end

  shared_context 'oystercard just finished journey' do
    before do
      journey.touch_in(entry_station, oystercard)
      journey.touch_out(exit_station, oystercard)
    end
  end

  it 'can create instances of the journey class' do
    expect(journey).to be_kind_of Journey
  end

  describe '#touch_in' do
    it 'Cant be used if it doesnt have atleast £1' do
      expect { subject.touch_in(entry_station, oystercard) }.to raise_error 'Have insufficient funds'
    end
  end

  describe '#touch_in' do
    include_context 'fully topped up oystercard'
    include_context 'oystercard already in journey'

    it 'responds to the method touch in' do
      expect(journey).to respond_to(:touch_in).with(2).arguments
    end

    it 'stores the entry station' do
      expect(journey.touch_in(entry_station, oystercard)).to eq entry_station
    end

    it 'can touch in' do
      subject.touch_in(entry_station, oystercard)
      expect(subject).to be_in_journey
    end

    it 'has an empty list of journeys by default' do
      expect(subject.journeys).to be_empty
    end
  end

  describe '#touch_out' do
    include_context 'fully topped up oystercard'
    include_context 'oystercard just finished journey'

    it 'responds to the method touch out' do
      expect(journey).to respond_to(:touch_out).with(2).arguments
    end

    it 'stores the exit station' do
      expect(journey.touch_out(exit_station, oystercard)).to eq exit_station
    end

    it 'can touch out' do
      expect(subject).not_to be_in_journey
    end

    it 'stores the exit station' do
      expect(journey.exit_station).to eq exit_station
    end

    it 'deducts fare when touch_out' do
      minimum_fare = Oystercard::MINIMUM_FARE
      expect { journey.touch_out(exit_station, oystercard) }.to change { oystercard.balance }.by(-minimum_fare)
    end
  end

  describe '#in_journey?' do
    it 'is initially not in a journey' do
      expect(subject).not_to be_in_journey
    end
  end

  describe '#entry_station' do
    include_context 'fully topped up oystercard'

    it 'stores the entry station' do
      journey.touch_in(entry_station, oystercard)
      expect(journey.entry_station).to eq entry_station
    end
  end

  describe '#journeys' do
      it 'stores a journey' do
      expect(journey.journeys).to include { { entry_station: entry_station, exit_station: exit_station } }
    end
  end

  # describe '#fare' do
  #   it 'responds to the method fare' do
  #     expect(journey).to respond_to(:fare)
  #   end
  #
  #   it 'returns minimum fare if touch in and out' do
  #     expect(journey.fare).to eq Oystercard::MINIMUM_FARE
  #   end
  #
  #   it 'returns penalty fare if not touch in' do
  #     expect(journey.fare).to eq Oystercard::PENALTY_FARE
  #   end
  # end
end
