require_relative '../translation'
require_relative '../build_moves'

class Rook
  include Translation
  include BuildMoves
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
end
