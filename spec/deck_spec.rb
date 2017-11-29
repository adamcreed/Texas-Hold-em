require 'deck'

describe Deck do
  before do
    @deck = Deck.new
  end

  describe '#new' do
    it 'fills a deck with cards' do
      expect(@deck.cards.length).to eq 52
      expect(@deck.cards).to include(rank: 14, suit: 'Spades')
    end
  end
end
