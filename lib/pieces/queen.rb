require_relative '../translation'

class Queen < Rook
  include Translation
  attr_accessor :char, :moves, :name, :moved

  def initialize(color)
    @char = " \u265c  ".encode('utf-8')
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    @color = 'white'
    color_select(color)
    @name = 'Queen'
  end

  def color_select(color)
    if color == 'black'
      @char = " \u265b  ".encode('utf-8')
      @color = 'black'
    else
      @char = " \u2655  ".encode('utf-8')
      @color = 'white'
    end
  end
end
