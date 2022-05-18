require_relative '../translation'

class Rook
  include Translation
  attr_accessor :char, :moves, :name, :moved, :color

  def initialize(color)
    @char = " \u265c  ".encode('utf-8')
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    @color = 'white'
    color_select(color)
    @name = 'Rook'
  end

  def color_select(color)
    if color == 'black'
      @char = " \u265c  ".encode('utf-8')
      @color = 'black'
    else
      @char = " \u2656  ".encode('utf-8')
      @color = 'white'
    end
  end

  def build_moves(node, direction, moves = [])
    cell = node.traverse(node.data.add_array(direction))
    moves << translate(cell.data) unless cell.nil?
    return moves if cell.nil? || !cell.empty?

    build_moves(cell, direction, moves)
  end

  def show_moves(node, moves = [])
    @moves.each do |move|
      moves += build_moves(node, move)
    end
    moves
  end
end
