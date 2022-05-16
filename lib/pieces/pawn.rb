class Pawn
  attr_accessor :char, :moves, :name, :moved

  def initialize(color)
    @char = " \u265f  ".encode('utf-8')
    @moves = nil
    @color = 'white'
    color_behavior(color)
    @name = 'Pawn'
    @moved = false
  end

  def inspect
    @char
  end

  def color_behavior(color)
    if color == 'black'
      @char = " \u265f  ".encode('utf-8')
      @moves = [[-1, 0], [-2, 0], [-1, 1], [-1, -1]]
      @color = 'black'
    else
      @char = " \u2659  ".encode('utf-8')
      @moves = [[1, 0], [2, 0], [1, 1], [1, -1]]
      @color = 'white'
    end
  end

  def move
    @moves.delete_at(1) unless @moved
    @moved = true
  end
  # Stop the pawn from eating in vertical
  # Stop the pawn from moving diagonally unless it can eat
  # Stop all pieces except the knight from jumping above other pieces
end
