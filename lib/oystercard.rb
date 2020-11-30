class Oystercard

  attr_reader :balance
  BALANCE_LIMIT = 90

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

  def touch_in
    @in_use = true
  end
  
  def touch_out
    @in_use = false
  end

  def in_journey?
    @in_use
  end



end
