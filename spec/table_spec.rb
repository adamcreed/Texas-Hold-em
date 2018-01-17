require 'table'

describe Table do
  before do
    @table = Table.new
  end

  describe '#find_winners' do
    before :all do
      DummyPlayer = Struct.new(:hand)
      @p1 = DummyPlayer.new(value: 9, high: 5)
      @p2 = DummyPlayer.new(value: 6, high: 14, kickers: [6, 4, 3, 2])
      @p3 = DummyPlayer.new(value: 1, high: 14, kickers: [13, 12, 11, 4])
      @p4 = DummyPlayer.new(value: 1, high: 14, kickers: [13, 12, 11, 4])
      @p5 = DummyPlayer.new(value: 1, high: 14, kickers: [13, 12, 10, 4])
    end

    context 'when one player has the best hand' do
      it 'returns the player with the best hand' do
        players = [@p1, @p2, @p3]

        @table.find_winners players: players

        expect(@table.winners).to eq [@p1]
      end
    end

    context 'when players are tied' do
      it 'returns all players with the best hand' do
        players = [@p3, @p4, @p5]

        @table.find_winners players: players

        expect(@table.winners).to eq [@p3, @p4]
      end
    end
  end
end
