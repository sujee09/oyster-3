class Oystercard

  attr_reader :balance, :entry_station

  BALANCE_LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    fail "Can't exceed the limit of £#{BALANCE_LIMIT}" if @balance + amount > BALANCE_LIMIT
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in(station)
    fail "Have insufficient funds" if @balance < MINIMUM_FARE
    @entry_station = station
    @in_use = true
  end

  def touch_out
    deduct_fare(MINIMUM_FARE)
    @entry_station = nil
  end

  def in_journey?
    !!entry_station
  end

  private

  def deduct_fare(fare = MINIMUM_FARE)
    @balance -= fare
  end

end
