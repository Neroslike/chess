require './lib/node_class.rb'

describe Node do
  subject(:node) { described_class.new([0, 0]) }
  describe '#empty?' do
    context 'when the node has no piece' do
      it 'returns true' do
        expect(node.empty?).to be true
      end
    end

    context 'when the node has a piece' do
      it 'returns false' do
        node.piece = 'knight'
        expect(node.empty?).to be false
      end
    end
  end

  describe '#traverse' do
    context 'from 0, 0 to 7, 7' do
      it 'returns the destination object data' do
        node.build_graph
        expect(node.traverse([7, 7]).data).to eq([7, 7])
      end
    end

    context 'from 0, 0 to 6, 6' do
      it 'returns the destination object data' do
        node.build_graph
        expect(node.traverse([6, 6]).data).to eq([6, 6])
      end
    end
  end
end
