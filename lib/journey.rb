require_relative 'oystercard'

class Journey
  attr_reader :entry_station, :exit_station, :journeys

  def initialize
    @entry_station = nil
    @exit_station = nil
    @journeys = {}
  end

  def touch_in(entry_station, oystercard)
    raise 'Have insufficient funds' if oystercard.balance < Oystercard::MINIMUM_FARE

    @entry_station = entry_station
    @journeys['entry_station'] = entry_station
  end

  def touch_out(exit_station, oystercard)
    raise 'Have insufficient funds' if oystercard.balance < Oystercard::MINIMUM_FARE

    oystercard.deduct(Oystercard::MINIMUM_FARE)
    @exit_station = exit_station
    @journeys['exit_station'] = exit_station
  end

  def in_journey?
    !!entry_station
  end

  # def fare
  #   if @entry_station != nil && @exit_station != nil
  #     Oystercard::MINIMUM_FARE
  #   else
  #     Oystercard::PENALTY_FARE
  #   end
  # end
end
