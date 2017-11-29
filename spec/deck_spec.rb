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
end
