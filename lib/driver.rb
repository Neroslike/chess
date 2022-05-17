require_relative 'board'

board = Board.new
board.place_piece('b1', Pawn.new('white'))
board.place_piece('b4', Pawn.new('black'))
board.place_piece('c4', Pawn.new('black'))
board.place_piece('a4', Pawn.new('black'))
board.display_board
loop do
  board.select_piece
  board.display_board
end
