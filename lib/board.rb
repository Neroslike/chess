require_relative 'node_class'
require_relative 'pieces/pawn'
require 'colorize'
class Board
  attr_accessor :board, :pawn

  def initialize
    @board = Node.new([0, 0]).build_graph
  end

  def display_board(output = '', node = @board.traverse([7, 0]))
    until node.nil?
      color = (node.data[0] % 2).zero? ? :magenta : :black
      output += display_row(node, color)
      node = node.down
    end
    puts output
  end

  def display_row(node = @board.traverse([7, 0]), color = :black, output = '')
    return output if node.nil?

    output += node.char.colorize(background: color)
    output += "\n" if node.data[1] == 7
    color = color == :black ? :magenta : :black
    output = display_row(node.right, color, output)
  end

  def place_piece(coordinates)
    node = @board.traverse(coordinates)
    node.piece = Pawn.new
    node.char = node.piece.char
  end
end

board = Board.new
board.place_piece([7, 3])
board.display_board
