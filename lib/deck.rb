# A deck of cards
class Deck
  attr_accessor :cards

  def initialize
    @cards = []

    2.upto(14) do |rank| # 11-14 are face cards/Ace
      fill_rank rank
    end
  end

  def fill_rank(rank)
    suits = %w(Clubs Diamonds Hearts Spades)

    4.times do |suit|
      @cards << { rank: rank, suit: suits[suit] }
    end
  end
end
