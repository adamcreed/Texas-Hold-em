# Controls player actions
class Player
  attr_accessor :cards, :chips

  def initialize(chips: 2_000)
    @cards = []
    @chips = chips
    @all_in = false
  end

  def bet(amount:, table:, ante: false)
    # TODO: side pots
    @chips -= amount
    table.pot += amount
    table.bet = amount unless ante
  end
end
