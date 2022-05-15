class Pawn
  attr_accessor :char, :moves, :name

  def initialize
    @char = " \u265f  ".encode('utf-8')
    @moves = [[1, 0], [1, 1], [1, -1], [2, 0]]
    @name = 'Pawn'
  end

  def inspect
    @char
  end
end
