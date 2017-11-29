# Holds community cards and pot
class Table
  attr_accessor :cards, :burned, :pot, :bet

  def initialize
    @cards = []
    @burned = []
    @pot = 0
    @bet = 0
  end
end
