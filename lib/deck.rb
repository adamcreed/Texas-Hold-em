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

  def shuffle!
    @cards.shuffle!
  end

  def deal_to(target)
    target << @cards.pop
  end

  def to_s(card:, form: 'Short')
    ranks = { 2 => 'Two', 3 => 'Three', 4 => 'Four', 5 => 'Five',
              6 => 'Six', 7 => 'Seven', 8 => 'Eight', 9 => 'Nine',
              10 => 'Ten', 11 => 'Jack', 12 => 'Queen', 13 => 'King',
              14 => 'Ace' }

    if form == 'Full'
      "#{ranks[card[:rank]]} of #{card[:suit]}"
    else
      short = card[:rank] >= 10 ? ranks[card[:rank]][0] : card[:rank]

      "#{short}#{card[:suit][0].downcase}"
    end
  end
end
