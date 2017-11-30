require 'app'

describe 'App' do
  before do
    @deck, @players, @table = start_game
  end

  describe '#start_hand' do
    it 'shuffles the deck, seeds pot, and deals two cards to each player' do
      start_hand players: @players, deck: @deck, table: @table
      expected_pot = @table.blind * 3 + @table.ante * @players.length

      expect(@deck.cards.length).to eq 34
      expect(@players).to all(satisfy { |p| p.cards.length == 2 })
      expect(@table.pot).to eq expected_pot
      expect(@table.bet).to eq @table.blind * 2
      expect(@table.current_action).to eq 3
    end
  end
end
