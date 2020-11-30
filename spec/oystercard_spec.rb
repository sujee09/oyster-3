require 'oystercard'

describe Oystercard do
  card = Oystercard.new
  it "Should be an instance of the Oystercard class" do
    expect(card).to be_instance_of Oystercard
  end

  it "Checks if the new card has a 0 balance" do
    expect(card.balance).to eq 0
  end
end
