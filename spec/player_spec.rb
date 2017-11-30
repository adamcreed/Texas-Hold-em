require 'player'

describe Player do
  before do
    @player = Player.new
  end

  describe '#new' do
    context 'When starting chips are not specified' do
      it 'creates a player with 2,000 chips' do
        expect(@player.chips).to eq 2_000
      end
    end

    context 'when starting chips are specified' do
      it 'creates a player with the given chip amount' do
        player = Player.new chips: 5_000

        expect(player.chips).to eq 5_000
      end
    end
  end

  describe '#bet' do
    it "moves the bet amount from the player's chips to the pot" do
      DummyTable = Struct.new(:pot, :bet)
      table = DummyTable.new(0, 0)

      @player.bet amount: 500, table: table

      expect(@player.chips).to eq 1_500
      expect(table.bet).to eq 500
      expect(table.pot).to eq 500
    end
  end
end
