require_relative 'node_class'
require_relative 'pieces/pawn'
require_relative 'translation'
require 'colorize'
class Board
  include Translation
  attr_accessor :board, :pawn

  def initialize
    @board = Node.new([0, 0]).build_graph
    @turn = 2
  end

  def display_board(output = '', node = @board.traverse([7, 0]))
    count = 8
    until node.nil?
      color = (node.data[0] % 2).zero? ? :magenta : :black
      output += "#{count} #{display_row(node, color)}"
      node = node.down
      count -= 1
    end
    puts "#{output}   A   B   C   D   E   F   G   H"
  end

  def display_row(node = @board.traverse([7, 0]), color = :black, output = '')
    return output if node.nil?

    output += node.char.colorize(background: color)
    output += "\n" if node.data[1] == 7
    color = color == :black ? :magenta : :black
    display_row(node.right, color, output)
  end

  def place_piece(coordinates, piece)
    node = @board.traverse(translate(coordinates))
    node.piece = piece
    node.char = node.piece.char
  end

  def display_moves(node)
    node.piece.moves.filter_map do |move|
      coordinate = node.data.add_array(move)
      translate(coordinate) if coordinate.legal_move?
    end
  end

  def select_piece
    puts 'Select a piece to move'
    piece = translate(gets.chomp)
    node = @board.traverse(piece)
    moves = node.piece.show_moves(node)
    puts "The possible moves for the #{node.piece.name} are: #{moves}"
    puts 'Select a move'
    move = ''
    loop do
      move = gets.chomp
      moves.include?(move) ? break : puts('Please enter a valid move')
    end
    move_piece(node, move)
  end

  def move_piece(piece, move)
    puts '================'
    puts "#{translate(piece.data)} #{piece.piece.name} to #{move}"
    puts '================'
    place_piece(move, piece.piece)
    piece.remove_piece
  end
end
