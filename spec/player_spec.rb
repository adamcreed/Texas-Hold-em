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
    it "subtracts the bet amount from the player's chips" do
      @player.bet 500

      expect(@player.chips).to eq 1_500
    end
  end
end
