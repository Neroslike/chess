require_relative '../translation'
class Pawn
  include Translation
  attr_accessor :char, :moves, :name, :moved

  def initialize(color)
    @char = " \u265f  ".encode('utf-8')
    @moves = nil
    @color = 'white'
    color_behavior(color)
    @name = 'Pawn'
    @moved = false
  end

  def inspect
    @char
  end

  def color_behavior(color)
    if color == 'black'
      @char = " \u265f  ".encode('utf-8')
      @moves = [[-1, 0], [-1, 1], [-1, -1]]
      @color = 'black'
    else
      @char = " \u2659  ".encode('utf-8')
      @moves = [[1, 0], [1, 1], [1, -1]]
      @color = 'white'
    end
  end

  def first_move
    @color == 'black' ? [-2, 0] : [2, 0]
  end

  def blocked?(node)
    !node.traverse(node.data.add_array(@moves[0])).empty?
  end

  def filter_movements(move, node)
    # Return true if it can eat vertically and move diagonally without eating
    (move.diagonal?(node.data) && node.traverse(move).empty?) || (!move.diagonal?(node.data) && !node.traverse(move).empty?)
  end

  def show_moves(node, moves = [])
    # Get array of all possible legal moves
    moves << first_move unless blocked?(node) || @moved
    moves += @moves
    moves = moves.filter_map do |move|
      coordinate = node.data.add_array(move)
      coordinate if coordinate.legal_move? && !filter_movements(coordinate, node)
    end
    @moved = true
    moves.map { |move| translate(move) }
  end
  # Stop the pawn from eating in vertical. Done
  # Stop the pawn from moving diagonally unless it can eat. Done
  # Stop all pieces except the knight from jumping above other pieces
end
