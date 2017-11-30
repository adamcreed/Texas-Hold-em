require_relative 'deck'
require_relative 'player'
require_relative 'table'

def main
  deck, players, table = start_game
  shuffle_up_and_deal players: players, deck: deck
end

def start_game
  deck = Deck.new
  players = Array.new(9) { Player.new }
  table = Table.new

  [deck, players, table]
end

def shuffle_up_and_deal(players:, deck:)
  deck.shuffle!

  2.times do
    players.each { |player| deck.deal_to(player.cards) }
  end
end

main if __FILE__ == $PROGRAM_NAME
