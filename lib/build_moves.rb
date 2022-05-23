module BuildMoves
  def build_moves(node, direction, moves = [])
    cell = node.traverse(node.data.add_array(direction))
    moves << translate(cell.data) unless cell.nil?
    return moves if cell.nil? || !cell.empty?

    build_moves(cell, direction, moves)
  end

  def show_moves(node, move_array = self.moves, moves = [])
    move_array.each do |move|
      moves += build_moves(node, move)
    end
    moves
  end

  def show_pieces_knight(node, moves)
    moves = moves.filter_map do |move|
      cell = node.traverse(node.data.add_array(move))
      translate(cell.data) unless cell.nil?
    end
    moves.reject { |piece| node.traverse(translate(piece)).empty? }
  end

  def show_pieces(node, move_array, pieces = [])
    move_array.each do |move|
      pieces += build_moves(node, move).reject { |piece| node.traverse(translate(piece)).empty? }
    end
    pieces
  end

  def travail(from, to)
    from = @board.traverse(translate(from))
    from.piece.moves.each do |move|
      moves = [translate(from.data)] + build_moves(from, move)
      return moves if moves.include?(to)
    end
  end
end
