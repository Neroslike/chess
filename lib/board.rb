require_relative 'node_class'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/knight'
require_relative 'pieces/king'
require_relative 'translation'
require_relative 'build_board'
require_relative 'build_moves'
require 'colorize'

class Board
  include Translation
  include BuildBoard
  include BuildMoves
  include JSONable
  attr_accessor :board, :pawn, :white_king, :black_king

  def initialize
    @board = Node.new([0, 0]).build_graph
    @turn = 2
    @white_king = nil
    @black_king = nil
    @last_move = nil
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
    @black_king = coordinates if piece.color == 'black' && piece.name == 'King'
    @white_king = coordinates if piece.color == 'white' && piece.name == 'King'
    node.piece = piece
    node.char = node.piece.char
    piece
  end

  def filter_enemy_moves(moves, piece)
    moves.reject do |move|
      node = @board.traverse(translate(move))
      node.piece.color == piece.piece.color unless node.nil? || node.empty?
    end
  end

  def save_game(string = 'save.json')
    Dir.mkdir('Savegames') unless File.exist?('Savegames')
    File.open("Savegames/#{string}", 'w') do |file|
      file.write(@board.to_json)
    end
  end

  def load_game(string = 'save.json')
    File.open("Savegames/#{string}", 'r') { |file| from_json!(file.read) }
  end

  def select_piece(turn)
    puts "White King: #{@white_king}\nBlack King: #{@black_king}"
    puts "white check: #{check?(@white_king)}"
    puts "black check: #{check?(@black_king)}"
    puts 'Select a piece to move'
    piece = translate(gets.chomp.downcase)
    node = @board.traverse(piece)
    moves = filter_enemy_moves(node.piece.show_moves(node), node)
    puts "The possible moves for the #{node.piece.name} are: #{moves}"
    puts 'Select a move'
    move = ''
    loop do
      move = gets.chomp.downcase
      moves.include?(move) ? break : puts('Please enter a valid move')
    end
    save_game('before_check.json')
    move_piece(node, move)
    # if check?(@black_king) || check?(@white_king)
    #   puts "You can't make make that move because it checks your king"
    #   load_game('before_check.json')
    # end
  end

  def play_game
    turn = 'white'
    loop do

    end
  end

  def move_piece(piece, move)
    cell = @board.traverse(translate(move))
    puts '================'
    puts "#{translate(piece.data).capitalize} #{piece.piece.color.capitalize} #{piece.piece.name} to #{move.capitalize} #{cell.piece.color.capitalize unless cell.empty?} #{cell.piece.name unless cell.empty?}"
    puts '================'
    place_piece(move, piece.piece)
    piece.remove_piece
  end

  def check?(king)
    !check(filter_pieces(@board.traverse(translate(king))), king).empty?
  end

  def filter_pieces(node)
    moves = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    knight_moves = [[-1, -2], [1, 2], [-2, -1], [2, 1], [1, -2], [-1, 2], [2, -1], [-2, 1]]
    all_moves = show_pieces(node, moves) + show_pieces_knight(node, knight_moves)
    filter_enemy_moves(all_moves, node)
  end

  def check(pieces, king)
    pieces.select do |piece|
      node = @board.traverse(translate(piece))
      filter_enemy_moves(node.piece.show_moves(node), node).include?(king)
    end
  end
end
