require_relative 'board'

board = Board.new
board.build_board
# board.load_game
board.display_board
loop do
  board.select_piece
  board.display_board
end
