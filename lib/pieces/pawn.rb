class Pawn
  attr_accessor :char, :move

  def initialize
    @char = " \u265f  ".encode('utf-8')
    @moves = [[1, 0], [1, 1], [1, -1], [2, 0]]
  end

  def inspect
    @char
  end
end
