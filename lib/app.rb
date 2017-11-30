require_relative 'deck'
require_relative 'player'
require_relative 'table'

def main
  deck, players, table = start_game
  start_hand players: players, deck: deck, table: table
end

def start_game
  deck = Deck.new
  players = Array.new(9) { Player.new }
  table = Table.new

  [deck, players, table]
end

def start_hand(players:, deck:, table:)
  deck.shuffle!
  seed_pot players: players, table: table

  2.times do
    players.each { |player| deck.deal_to(player.cards) }
  end
end

def seed_pot(players:, table:)
  collect_ante players: players, table: table
  collect_blinds players: players, table: table
end

def collect_ante(players:, table:)
  players.each do |player|
    ante = [player.chips, table.ante].min
    # TODO: all-in checks
    player.bet amount: ante, table: table, ante: true
  end
end

def collect_blinds(players:, table:)
  # TODO: all-in checks
  blind = table.blind

  1.upto 2 do |position|
    table.move_action players
    players[table.current_action].bet amount: blind * position, table: table
  end

  table.bet = blind * 2
  table.move_action players
  table.last_action = nil
end

main if __FILE__ == $PROGRAM_NAME
