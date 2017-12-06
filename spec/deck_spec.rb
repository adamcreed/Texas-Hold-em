require 'deck'

describe Deck do
  before do
    @deck = Deck.new
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
    before do
      @ace_of_spades = { rank: 14, suit: 'Spades' }
      @two_of_clubs = { rank: 2, suit: 'Clubs' }
      @ten_of_hearts = { rank: 10, suit: 'Hearts' }
    end

    context 'When full is specified' do
      it 'gives the full name of a card' do
        expect(@deck.to_s(card: @ace_of_spades, form: 'Full'))
          .to eq 'Ace of Spades'

        expect(@deck.to_s(card: @two_of_clubs, form: 'Full'))
          .to eq 'Two of Clubs'
        expect(@deck.to_s(card: @ten_of_hearts, form: 'Full'))
          .to eq 'Ten of Hearts'
      end
    end

    context 'When no form is specified' do
      it 'gives the short name of a card' do
        expect(@deck.to_s(card: @ace_of_spades)).to eq 'As'
        expect(@deck.to_s(card: @two_of_clubs)).to eq '2c'
        expect(@deck.to_s(card: @ten_of_hearts)).to eq 'Th'
      end
    end
  end
end
