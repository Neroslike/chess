require './lib/board.rb'
describe Board do
  subject(:game_board) { described_class.new }
  describe '#initialize' do
    # No test necessary, but the inside methods should be tested.
  end

  describe '#display_board' do
    # puts displaying method, no testing needed.
  end

  describe '#display_row' do
    # puts displaying method, no testing needed.
  end

  describe '#place_piece' do
    # Public script method, no testing needed but the methods inside should.
  end

  describe '#translate' do
    context 'when the input is an array' do
      it 'returns the coordinates in chess notation' do
        coordinates = [1, 2]
        expect(game_board.translate(coordinates)).to eq('c2')
      end
    end

    context 'when the input is a chess notation' do
      it 'returns the coordinates in an array' do
        coordinates = 'b4'
        expect(game_board.translate(coordinates)).to eq([3, 1])
      end
    end
  end

  describe '#array_to_notation' do
    #already tested above
  end

  describe '#notation_to_array' do
    #already tested above
  end

  describe '#display_moves' do
    context 'if the piece is a white pawn in a1' do
      it 'returns pawn possible movements' do
        node = Node.new([0, 0])
        node.piece = Pawn.new('white')
        expect(game_board.display_moves(node)).to contain_exactly('a3', 'b2', 'a2')
      end
    end

    context 'if the piece is a black pawn in a8' do
      it 'returns pawn possible movements' do
        node = Node.new([7, 0])
        node.piece = Pawn.new('black')
        expect(game_board.display_moves(node)).to contain_exactly('a7', 'b7', 'a6')
      end
    end
  end

  describe '#select_piece' do
    # Public script method, no testing needed but the methods inside should.
  end
end
