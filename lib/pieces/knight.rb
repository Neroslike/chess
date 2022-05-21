require_relative '../translation'

class Knight < Rook
  def initialize(color)
    @char = " \u265c  ".encode('utf-8')
    @moves = [[-1, -2], [1, 2], [-2, -1], [2, 1], [1, -2], [-1, 2], [2, -1], [-2, 1]]
    @color = 'white'
    color_select(color)
    @name = 'Knight'
  end

  def color_select(color)
    if color == 'black'
      @char = " \u265e  ".encode('utf-8')
      @color = 'black'
    else
      @char = " \u2658  ".encode('utf-8')
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
