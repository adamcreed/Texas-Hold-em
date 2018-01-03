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

  def hand_value(cards:)
    sorted_cards = sort_rank cards: cards
    ranks = get_ranks cards: sorted_cards

    # Straight Flush check
    flush_cards = check_flush cards: sorted_cards
    straight_flush_cards = check_straight cards: flush_cards if flush_cards

    if straight_flush_cards
      return { type: 'Straight Flush',
               high: straight_flush_cards.last[:rank] }
    end

    # Four of a Kind check
    quads = check_four_of_a_kind ranks: ranks

    if quads
      kickers = find_kickers ranks: ranks, high: quads, count: 1
      return { type: 'Four of a Kind',
               high: quads,
               kickers: kickers }
    end

    # Full House check
    trips, pair = check_full_house ranks: ranks

    if trips && pair
      return { type: 'Full House',
               high: trips,
               low: pair }
    end

    # Flush check
    if flush_cards
      ranks = get_ranks cards: flush_cards
      high = ranks.last
      kickers = find_kickers ranks: ranks, high: high, count: 4
      return { type: 'Flush',
               high: high,
               kickers: kickers }
    end

    # Straight check
    straight_cards = check_straight cards: sorted_cards

    if straight_cards
      return { type: 'Straight',
               high: straight_cards.last[:rank] }
    end

    # Three of a Kind check
    if trips
      kickers = find_kickers ranks: ranks, high: trips, count: 2

      return { type: 'Three of a Kind',
               high: trips,
               kickers: kickers }
    end

    # Two Pair check
    two = check_two_pair ranks: ranks, pair: pair

    if two
      kickers = find_kickers ranks: ranks, high: pair, low: two, count: 1
      return { type: 'Two Pair',
               high: pair,
               low: two,
               kickers: kickers }
    end

    # One Pair check
    if pair
      kickers = find_kickers ranks: ranks, high: pair, count: 3
      return { type: 'One Pair',
               high: pair,
               kickers: kickers }
    end

    # High Card
    high = ranks.last
    kickers = find_kickers ranks: ranks, high: high, count: 4

    { type: 'High Card',
      high: high,
      kickers: kickers }
  end

  def check_flush(cards:)
    suit_counters = { 'Clubs' => 0, 'Diamonds' => 0,
                      'Hearts' => 0, 'Spades' => 0 }

    cards.each do |card|
      suit = card[:suit]
      suit_counters[suit] += 1
      return flush_cards cards: cards, suit: suit if suit_counters[suit] >= 5
    end

    nil
  end

  def flush_cards(cards:, suit:)
    cards.select { |card| card[:suit] == suit }
  end

  def check_straight(cards:)
    unique_cards = remove_pairs cards: cards
    unique_cards.unshift rank: 1 if hand_has_ace? cards: cards
    start = unique_cards.length - 5

    start.downto 0 do |first_card|
      potential_hand = unique_cards[first_card..first_card + 4]
      return potential_hand if straight? cards: potential_hand
    end

    nil
  end

  def check_four_of_a_kind(ranks:)
    0.upto ranks.length - 3 do |rank|
      return ranks[rank] if ranks.count(ranks[rank]) == 4
    end

    nil
  end

  def check_full_house(ranks:)
    trips = pair = nil
    start = ranks.length - 2

    start.downto 1 do |rank|
      card = ranks[rank]

      trips = card if ranks.count(card) == 3 && !trips
      pair = card if ranks.count(card) >= 2 && card != trips && !pair
    end

    [trips, pair]
  end

  def check_two_pair(ranks:, pair:)
    return unless pair

    two = nil

    0.upto ranks.length - 3 do |rank|
      two = ranks[rank] if ranks.count(ranks[rank]) == 2 && ranks[rank] != pair
    end

    two
  end

  def remove_pairs(cards:)
    cards.uniq { |card| card[:rank] }
  end

  def hand_has_ace?(cards:)
    cards.find { |card| card[:rank] == 14 }
  end

  def sort_rank(cards:)
    cards.sort { |a, b| a[:rank] <=> b[:rank] }
  end

  def straight?(cards:)
    ranks = get_ranks cards: cards

    ranks == (ranks[0]..ranks[4]).to_a
  end

  def get_ranks(cards:)
    cards.map { |card| card[:rank] }
  end

  def find_kickers(ranks:, count:, high:, low: 0)
    kickers = []

    ranks.reverse.each do |rank|
      kickers << rank if rank != high && rank != low && kickers.length < count
    end

    kickers
  end
end
