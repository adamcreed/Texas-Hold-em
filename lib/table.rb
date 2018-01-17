# Holds community cards and pot
class Table
  attr_accessor :cards, :muck, :pot, :side_pots, :winners, :bet, :blind, :ante,
                :dealer_button, :current_action, :last_action

  def initialize
    @cards = []
    @muck = []
    @pot = 0
    @side_pots = []
    @winners = []
    @bet = 0
    @blind = 5
    @ante = 0
    @dealer_button = 0
    @current_action = 0
    @last_action = 0
  end

  def move_action(players:)
    @current_action = end_of_table?(players: players) ? 0 : @current_action + 1
  end

  def end_of_table?(players:)
    @current_action + 1 >= players.length
  end

  def find_winners(players:)
    winning_hand = { value: 0 }

    players.each do |player|
      winning_hand = compare_hand best: winning_hand, player: player
    end
  end

  def compare_hand(best:, player:)
    return best if player.hand[:value] < best[:value]

    if player.hand[:value] > best[:value]
      @winners = [player]
      return player.hand
    end

    # Hand values are equal
    if player.hand[:high] > best[:high]
      @winners = [player]
      return player.hand
    end

    # Highs are equal
    if player.hand[:low] && player.hand[:low] > best[:low]
      @winners = [player]
      return player.hand
    end

    # Lows are equal
    if player.hand[:kickers]
      winner = compare_kickers best: best, player: player
      return winner if winner
    end

    # Hands are equal
    @winners << player
    best
  end

  def compare_kickers(best:, player:)
    winner = nil

    player.hand[:kickers].length.times do |kicker|
      winner = compare_kicker best: best, player: player, kicker: kicker
      break if winner
    end

    winner
  end

  def compare_kicker(best:, player:, kicker:)
    return best if player.hand[:kickers][kicker] < best[:kickers][kicker]

    if player.hand[:kickers][kicker] > best[:kickers][kicker]
      @winners = [player]
      return player.hand
    end

    nil
  end
end
