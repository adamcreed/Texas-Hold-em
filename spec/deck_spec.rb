require 'deck'

describe Deck do
  before do
    @deck = Deck.new
  end

  before :all do
    def fill_rank(rank:, cards:)
      cards[rank] = {}
      suits = %w(Clubs Diamonds Hearts Spades)

      4.times do |suit|
        cards[rank][suits[suit][0]] = { rank: rank, suit: suits[suit] }
      end
    end

    @cards = []

    2.upto(14) do |rank|
      fill_rank rank: rank, cards: @cards
    end
  end

  describe '#new' do
    it 'fills a deck with cards' do
      expect(@deck.cards.length).to eq 52
    end
  end

  describe '#deal_to' do
    it 'deals cards to a player or the board' do
      hand = []
      @deck.deal_to(hand)

      expect(hand.length).to eq 1
      expect(@deck.cards.length).to eq 51
      expect(@deck.cards).not_to include(hand[0])
    end
  end

  describe '#to_s' do
    context 'When full is specified' do
      it 'gives the full name of a card' do
        expect(@deck.to_s(card: @cards[14]['S'], form: 'Full'))
          .to eq 'Ace of Spades'
        expect(@deck.to_s(card: @cards[2]['C'], form: 'Full'))
          .to eq 'Two of Clubs'
        expect(@deck.to_s(card: @cards[10]['H'], form: 'Full'))
          .to eq 'Ten of Hearts'
      end
    end

    context 'When no form is specified' do
      it 'gives the short name of a card' do
        expect(@deck.to_s(card: @cards[14]['S'])).to eq 'As'
        expect(@deck.to_s(card: @cards[2]['C'])).to eq '2c'
        expect(@deck.to_s(card: @cards[10]['H'])).to eq 'Th'
      end
    end
  end

  describe '#hand_value' do
    context 'when given a Straight Flush' do
      it 'reports a Straight Flush to the appropriate high' do
        one = [@cards[14]['S'], @cards[2]['S'], @cards[3]['S'], @cards[4]['S'],
               @cards[5]['S'], @cards[8]['S'], @cards[11]['S']]
        one_expected = { type: 'Straight Flush', value: 9, high: 5 }

        two = [@cards[11]['S'], @cards[12]['S'], @cards[9]['S'], @cards[4]['S'],
               @cards[10]['S'], @cards[13]['S'], @cards[14]['S']]
        two_expected = { type: 'Straight Flush', value: 9, high: 14 }

        expect(@deck.hand_value(cards: one)).to eq one_expected
        expect(@deck.hand_value(cards: two)).to eq two_expected
      end
    end

    context 'when given a Four of a Kind' do
      it 'reports a Four of a Kind of the appropriate values' do
        one = [@cards[5]['C'], @cards[5]['D'], @cards[5]['H'], @cards[5]['S'],
               @cards[14]['S'], @cards[8]['S'], @cards[11]['S']]
        one_expected = { type: 'Four of a Kind', value: 8, high: 5,
                         kickers: [14] }

        two = [@cards[14]['C'], @cards[14]['D'], @cards[5]['H'], @cards[5]['S'],
               @cards[14]['H'], @cards[14]['S'], @cards[13]['S']]
        two_expected = { type: 'Four of a Kind', value: 8, high: 14,
                         kickers: [13] }

        expect(@deck.hand_value(cards: one)).to eq one_expected
        expect(@deck.hand_value(cards: two)).to eq two_expected
      end
    end

    context 'when given a Full House' do
      it 'reports a Full House of the appropriate values' do
        one = [@cards[5]['C'], @cards[5]['D'], @cards[5]['H'], @cards[6]['S'],
               @cards[6]['D'], @cards[8]['S'], @cards[11]['S']]
        one_expected = { type: 'Full House', value: 7, high: 5, low: 6 }

        two = [@cards[5]['C'], @cards[5]['D'], @cards[5]['H'], @cards[14]['C'],
               @cards[14]['H'], @cards[14]['S'], @cards[13]['S']]
        two_expected = { type: 'Full House', value: 7, high: 14, low: 5 }

        expect(@deck.hand_value(cards: one)).to eq one_expected
        expect(@deck.hand_value(cards: two)).to eq two_expected
      end
    end

    context 'when given a Flush' do
      it 'reports a Flush of the appropriate values' do
        one = [@cards[2]['C'], @cards[3]['C'], @cards[4]['C'], @cards[6]['C'],
               @cards[14]['C'], @cards[8]['S'], @cards[11]['S']]
        one_expected = { type: 'Flush', value: 6, high: 14,
                         kickers: [6, 4, 3, 2] }

        two = [@cards[2]['D'], @cards[11]['D'], @cards[9]['D'], @cards[12]['D'],
               @cards[6]['D'], @cards[8]['D'], @cards[5]['D']]
        two_expected = { type: 'Flush', value: 6, high: 12,
                         kickers: [11, 9, 8, 6] }

        expect(@deck.hand_value(cards: one)).to eq one_expected
        expect(@deck.hand_value(cards: two)).to eq two_expected
      end
    end

    context 'when given a Straight' do
      it 'reports a Straight to the appropriate high' do
        one = [@cards[2]['C'], @cards[3]['C'], @cards[4]['C'], @cards[5]['C'],
               @cards[12]['D'], @cards[14]['S'], @cards[11]['S']]
        one_expected = { type: 'Straight', value: 5, high: 5 }

        two = [@cards[8]['D'], @cards[9]['D'], @cards[10]['D'], @cards[10]['C'],
               @cards[11]['C'], @cards[11]['S'], @cards[7]['H']]
        two_expected = { type: 'Straight', value: 5, high: 11 }

        expect(@deck.hand_value(cards: one)).to eq one_expected
        expect(@deck.hand_value(cards: two)).to eq two_expected
      end
    end

    context 'when given a Three of a Kind' do
      it 'reports a Three of a Kind of the appropriate values' do
        one = [@cards[2]['C'], @cards[3]['C'], @cards[4]['C'], @cards[5]['C'],
               @cards[5]['D'], @cards[5]['S'], @cards[13]['S']]
        one_expected = { type: 'Three of a Kind', value: 4, high: 5,
                         kickers: [13, 4] }

        two = [@cards[8]['D'], @cards[9]['D'], @cards[12]['D'], @cards[13]['C'],
               @cards[14]['C'], @cards[14]['S'], @cards[14]['H']]
        two_expected = { type: 'Three of a Kind', value: 4, high: 14,
                         kickers: [13, 12] }

        expect(@deck.hand_value(cards: one)).to eq one_expected
        expect(@deck.hand_value(cards: two)).to eq two_expected
      end
    end

    context 'when given a Two Pair' do
      it 'reports a Two Pair of the appropriate values' do
        one = [@cards[6]['C'], @cards[6]['H'], @cards[5]['C'], @cards[5]['D'],
               @cards[8]['D'], @cards[12]['S'], @cards[14]['S']]
        one_expected = { type: 'Two Pair', value: 3, high: 6, low: 5,
                         kickers: [14] }

        two = [@cards[8]['D'], @cards[8]['H'], @cards[9]['D'], @cards[9]['C'],
               @cards[14]['C'], @cards[14]['S'], @cards[7]['H']]
        two_expected = { type: 'Two Pair', value: 3, high: 14, low: 9,
                         kickers: [8] }

        expect(@deck.hand_value(cards: one)).to eq one_expected
        expect(@deck.hand_value(cards: two)).to eq two_expected
      end
    end

    context 'when given a One Pair' do
      it 'reports a One Pair of the appropriate values' do
        one = [@cards[6]['C'], @cards[4]['H'], @cards[5]['C'], @cards[5]['D'],
               @cards[8]['D'], @cards[2]['S'], @cards[14]['S']]
        one_expected = { type: 'One Pair', value: 2, high: 5,
                         kickers: [14, 8, 6] }

        two = [@cards[2]['D'], @cards[2]['H'], @cards[3]['D'], @cards[4]['C'],
               @cards[5]['C'], @cards[7]['S'], @cards[8]['H']]
        two_expected = { type: 'One Pair', value: 2, high: 2,
                         kickers: [8, 7, 5] }

        expect(@deck.hand_value(cards: one)).to eq one_expected
        expect(@deck.hand_value(cards: two)).to eq two_expected
      end
    end

    context 'when given a High Card' do
      it 'reports a High Card of the appropriate values' do
        one = [@cards[2]['C'], @cards[3]['H'], @cards[4]['C'], @cards[5]['D'],
               @cards[7]['D'], @cards[8]['S'], @cards[9]['S']]
        one_expected = { type: 'High Card', value: 1, high: 9,
                         kickers: [8, 7, 5, 4] }

        two = [@cards[2]['D'], @cards[7]['H'], @cards[9]['D'], @cards[11]['C'],
               @cards[12]['C'], @cards[13]['S'], @cards[14]['H']]
        two_expected = { type: 'High Card', value: 1, high: 14,
                         kickers: [13, 12, 11, 9] }

        expect(@deck.hand_value(cards: one)).to eq one_expected
        expect(@deck.hand_value(cards: two)).to eq two_expected
      end
    end
  end
end
