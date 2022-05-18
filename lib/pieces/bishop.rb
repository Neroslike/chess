require_relative '../translation'

class Bishop < Rook
  include Translation
  attr_accessor :char, :moves, :name, :moved

  def initialize(color)
    @char = " \u265c  ".encode('utf-8')
    @moves = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    @color = 'white'
    color_select(color)
    @name = 'Bishop'
  end

  def color_select(color)
    if color == 'black'
      @char = " \u265d  ".encode('utf-8')
      @color = 'black'
    else
      @char = " \u2657  ".encode('utf-8')
      @color = 'white'
    end
  end
end
