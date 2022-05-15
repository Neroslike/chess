require_relative 'node_class'
require_relative 'pieces/pawn'
require 'colorize'
class Board
  attr_accessor :board, :pawn

  def initialize
    @board = Node.new([0, 0]).build_graph
  end

  def display_board(output = '', node = @board.traverse([7, 0]))
    count = 8
    until node.nil?
      color = (node.data[0] % 2).zero? ? :magenta : :black
      output += "#{count} #{display_row(node, color)}"
      node = node.down
      count -= 1
    end
    puts output + "   A   B   C   D   E   F   G   H"
  end

  def display_row(node = @board.traverse([7, 0]), color = :black, output = '')
    return output if node.nil?

    output += node.char.colorize(background: color)
    output += "\n" if node.data[1] == 7
    color = color == :black ? :magenta : :black
    output = display_row(node.right, color, output)
  end

  def place_piece(coordinates, piece)
    node = @board.traverse(translate(coordinates))
    node.piece = piece
    node.char = node.piece.char
  end

  def translate(value)
    if value.instance_of?(String)
      notation_to_array(value)
    else
      array_to_notation(value)
    end
  end

  def notation_to_array(string)
    string = string.split('').reverse
    string[1] = string[1].ord - 97
    string[0] = string[0].to_i - 1
    string
  end

  def array_to_notation(array)
    array.reverse!
    array[0] = (array[0] + 97).chr
    array[1] += 1
    array.join
  end

  def display_moves(node)
    moves = node.piece.moves.map { |move| translate(node.data.add_array(move))}
  end

  def select_piece
    puts 'Select a piece to move'
    piece = translate(gets.chomp)
    node = @board.traverse(piece)
    moves = display_moves(node)
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
    place_piece(move, piece)
    piece.remove_piece
  end
end

board = Board.new
board.place_piece('b2', Pawn.new)
board.display_board
board.select_piece
board.display_board
