# Controls player actions
class Player
  attr_accessor :cards, :chips

  def initialize(chips: 2_000)
    @cards = []
    @chips = chips
  end

  def bet(amount)
    @chips -= amount
  end
end
