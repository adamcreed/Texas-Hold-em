require 'app'

describe 'App' do
  before do
    @deck, @players, @table = start_game
  end

  describe '#shuffle_up_and_deal' do
    it 'shuffles the deck and deals two cards to each player' do
      shuffle_up_and_deal players: @players, deck: @deck

      expect(@deck.cards.length).to eq 34
      expect(@players).to all(satisfy { |p| p.cards.length == 2 })
    end
  end
end
