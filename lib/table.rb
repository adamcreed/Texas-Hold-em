# Holds community cards and pot
class Table
  attr_accessor :cards, :muck, :pot, :side_pots, :bet, :blind, :ante,
                :dealer_button, :current_action, :last_action

  def initialize
    @cards = []
    @muck = []
    @pot = 0
    @side_pots = []
    @bet = 0
    @blind = 5
    @ante = 0
    @dealer_button = 0
    @current_action = 0
    @last_action = 0
  end

  def move_action(players)
    @current_action = end_of_table?(players) ? 0 : @current_action + 1
  end

  def end_of_table?(players)
    @current_action + 1 >= players.length
  end
end
