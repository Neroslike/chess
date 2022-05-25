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

  def select_piece(color, moves = [], node = nil)
    puts "#{color.capitalize}'s turn"
    loop do
      piece = piece_input(color)
      node = @board.traverse(piece)
      moves = filter_enemy_moves(node.piece.show_moves(node), node)
      break unless moves.empty?
      puts 'That piece has no valid movements'
    end
    puts "The possible moves for the #{node.piece.name} are: #{moves}"
    puts 'Select a move'
    move = ''
    node.piece.moved = true if node.piece.name == 'Pawn'
    loop do
      move = gets.chomp.downcase
      moves.include?(move) ? break : puts('Please enter a valid move')
    end
    save_game('before_check.json')
    move_piece(node, move)
    restart_game if check_mate?(color)
    check_true if check?(color)
  end

  def piece_input(color)
    loop do
      puts "Select a piece to move (Or type '*' to save the game)"
      input = gets.chomp.downcase
      return check_piece_input(input, color) if input.valid_input?

      puts 'Invalid Input'
    end
  end

  def check_piece_input(input, color = 'white')
    loop do
      if input == '*'
        save_game
        exit
      end
      input = translate(input)
      node = @board.traverse(input)
      if node.empty?
        puts 'That cell is empty, select a valid piece'
        next
      end
      node.piece.color == color ? (return input) : (puts "You can't select that input")
    end
  end

  def play_game
    color = 'white'
    loop do
      display_board
      next if select_piece(color)

      color = color == 'white' ? 'black' : 'white'
    end
  end

  def load_game?
    puts 'Do you want to load the game? Y/N'
    loop do
      input = gets.chomp.downcase
      return if input == 'n'
      if input == 'y'
        load_game 
        break
      else
        puts 'Invalid input'
      end
    end
  end

  def restart_game
    loop do
      puts 'Do you want to play another game? Y/N'
      restart = gets.chomp.downcase
      if restart == 'y'
        @board.reset_graph
        @black_king = 'e8'
        @white_king = 'e1'
        build_board
        break
      elsif restart == 'n'
        exit
      else
        puts 'Invalid input'
      end
    end
  end

  # Loads the game right before the move was made
  def check_true
    puts "You can't make make that move because it checks your king"
    load_game('before_check.json')
    true
  end

  # Return true if an ally piece can get in the way or eat the piece that is checking
  def ally_help?(color)
    all_moves = ally_moves(color)
    danger_moves = check_moves(color)
    danger_moves.each do |move|
      return true if all_moves.include?(move)
    end
    false
  end

  def check_mate?(color)
    if king_unable_to_move?(color) && !ally_help?(color)
      loser = color == 'white' ? 'Black' : 'White'
      puts "#{loser} checkmate, #{color.capitalize}'s win!"
      display_board
      return true
    end
    false
  end

  # return true
  def king_unable_to_move?(color)
    king = color != 'white' ? @white_king : @black_king
    king_node = @board.traverse(translate(king))
    moves = filter_enemy_moves(king_node.piece.show_moves(king_node), king_node)
    threats = []
    moves.each do |move|
      checks = enemy_reach?(move, king_node.piece.color)
      threats << checks unless checks.empty?
      @board.traverse(translate(move)).remove_piece
    end
    moves.empty? ? false : threats.length == moves.length
  end

  # Return array of all possible moves of all the pieces of the given color
  def ally_moves(color)
    all_ally_moves = []
    @board.each do |node|
      if (!node.empty? && node.piece.color == color) && node.piece.name != 'King'
        all_ally_moves += filter_enemy_moves(node.piece.show_moves(node), node)
      end
    end
    all_ally_moves.uniq
  end

  # Calls #filter_pieces on a mock piece to determine if it's reachable by an enemy piece
  def enemy_reach?(coordinate, color)
    node = @board.traverse(translate(coordinate))
    place_piece(coordinate, Pawn.new(color)) if node.empty?
    check(filter_pieces(node), coordinate)
  end

  def move_piece(piece, move)
    cell = @board.traverse(translate(move))
    @black_king = move if piece.piece.color == 'black' && piece.piece.name == 'King'
    @white_king = move if piece.piece.color == 'white' && piece.piece.name == 'King'
    puts '================'
    puts "#{translate(piece.data).capitalize} #{piece.piece.color.capitalize} #{piece.piece.name} to #{move.capitalize} #{cell.piece.color.capitalize unless cell.empty?} #{cell.piece.name unless cell.empty?}"
    puts '================'
    if pawn_on_other_side?(piece, move)
      pawn_sacrifice(move, piece.piece.color)
    else
      place_piece(move, piece.piece)
    end
    piece.remove_piece
  end

  def pawn_sacrifice(coordinate, color)
    loop do
      puts 'You can exchange your pawn for one of these pieces, type its number'
      puts "1.Rook\n2.Bishop\n3.Queen\n4.Knight"
      piece = gets.chomp.to_i
      case piece
      when 1
        place_piece(coordinate, Rook.new(color))
        return
      when 2
        place_piece(coordinate, Bishop.new(color))
        return
      when 3
        place_piece(coordinate, Queen.new(color))
        return
      when 4
        place_piece(coordinate, Knight.new(color))
        return
      else
        puts 'Invalid input'
      end
    end
  end

  def pawn_on_other_side?(node, coordinates)
    if node.piece.name == 'Pawn'
      (node.piece.color == 'white' && node.data[0] == 6) || (node.piece.color == 'black' && node.data[0] == 1)
    end
  end

  # Return true if the king of the given color is on check
  def check?(color)
    king = color == 'white' ? @white_king : @black_king
    !check(filter_pieces(@board.traverse(translate(king))), king).empty?
  end

  # calls #check on the king of given color
  def check_moves(color)
    king = color == 'white' ? @white_king : @black_king
    enemy_pieces_moves = []
    pieces = check(filter_pieces(@board.traverse(translate(king))), king)
    pieces.each do |piece|
      enemy_pieces_moves += travail(piece, king)
    end
    enemy_pieces_moves.uniq
  end

  # Return an array of coordinates of all pieces that can reach the given node
  def filter_pieces(node)
    moves = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    knight_moves = [[-1, -2], [1, 2], [-2, -1], [2, 1], [1, -2], [-1, 2], [2, -1], [-2, 1]]
    all_moves = show_pieces(node, moves) + show_pieces_knight(node, knight_moves)
    filter_enemy_moves(all_moves, node)
  end

  # Return array of coordinates where there are pieces that can eat the king
  def check(pieces, king)
    pieces.select do |piece|
      node = @board.traverse(translate(piece))
      filter_enemy_moves(node.piece.show_moves(node), node).include?(king)
    end
  end
end
