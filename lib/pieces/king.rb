require_relative '../translation'

class King < Rook
  def initialize(color)
    @char = " \u265c  ".encode('utf-8')
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    @color = 'white'
    color_select(color)
    @name = 'King'
  end

  def color_select(color)
    if color == 'black'
      @char = " \u265a  ".encode('utf-8')
      @color = 'black'
    else
      @char = " \u2654  ".encode('utf-8')
      @color = 'white'
    end
  end

  def show_moves(node)
    @moves.filter_map do |move|
      cell = node.traverse(node.data.add_array(move))
      translate(cell.data) unless cell.nil?
    end
  end
end
