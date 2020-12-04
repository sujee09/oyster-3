require_relative 'station.rb'

class Oystercard
  attr_reader :balance, :entry_station, :exit_station

  BALANCE_LIMIT = 90
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    raise "Can't exceed the limit of £#{BALANCE_LIMIT}" if @balance + amount > BALANCE_LIMIT

    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  private

  def deduct_fare(fare = MINIMUM_FARE)
    @balance -= fare
  end
end
