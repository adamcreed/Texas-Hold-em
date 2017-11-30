# Holds community cards and pot
class Table
  attr_accessor :cards, :muck, :pot, :bet

  def initialize
    @cards = []
    @muck = []
    @pot = 0
    @bet = 0
  end
end
