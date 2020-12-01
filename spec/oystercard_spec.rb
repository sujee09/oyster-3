require 'oystercard'

describe Oystercard do
  shared_context 'fully topped up oystercard' do
    before do
      @balance_limit = Oystercard::BALANCE_LIMIT
      subject.top_up(@balance_limit)
    end
  end

  it "Should be an instance of the Oystercard class" do
    expect(subject).to be_instance_of Oystercard
  end

  describe '#balance' do
    it "Checks if the new card has a 0 balance" do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'should add amount to balance' do
      expect{ subject.top_up(5) }.to change{ subject.balance }.by 5
    end
  end

  describe '#top_up with full card' do
    include_context "fully topped up oystercard"

    it 'Throws an exception if balance limit is exceeded' do
      expect{ subject.top_up(1) }.to raise_error "Can't exceed the limit of £#{@balance_limit}"
    end
 end

  describe '#deduct' do
    it 'should deduct amount from balance' do
      subject.top_up(20)
      expect{ subject.deduct(5) }.to change{ subject.balance}.by (-5)
    end
  end

  # describe '#touch_in' do
  #
  #   it 'Should return true if card has been touched in' do
  #     expect(subject.touch_in).to eq true
  #   end
  # end
  #
  # describe '#touch_out' do
  #
  #   it 'Should return true if card has been touched out' do
  #     expect(subject.touch_out).to eq false
  #   end
  # end
  #
  # describe '#in_journey?' do
  #   it 'Should return true if in journey' do
  #     subject.touch_in
  #     expect(subject.in_journey?).to eq true
  #   end
  #
  #   it 'Should return false if not in journey' do
  #     subject.touch_out
  #     expect(subject.in_journey?).to eq false
  #   end
  # end


  describe '#in_journey?' do
    it 'is initially not in a journey' do
      expect(subject).not_to be_in_journey
    end
  end

  describe '#touch_in' do
    include_context "fully topped up oystercard"
    it 'can touch in' do
      subject.touch_in
      expect(subject).to be_in_journey
    end
  end

  describe '#touch_in' do
    it 'Cant be used if it doesnt have atleast £1' do
      expect { subject.touch_in }.to raise_error 'Have insufficient funds'
    end

    it 'Should allow to touch in' do
      subject.top_up(5)
      subject.touch_in
      expect(subject).to be_in_journey
    end
  end

  describe '#touch_out' do
    it 'can touch out' do
      subject.top_up(50)
      subject.touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end

    it 'deducts fare when touch_out' do
      minimum_fare = Oystercard::MINIMUM_FARE
      subject.top_up(10)
      subject.touch_in
      subject.touch_out
      expect{ subject.touch_out }.to change{ subject.balance }.by(-minimum_fare)
    end
  end

end
