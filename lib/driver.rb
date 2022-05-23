require_relative 'board'

board = Board.new
board.build_board
board.load_game?
board.play_game
