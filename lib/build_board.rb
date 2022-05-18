module BuildBoard
  def build_board
    place_pawns
    place_rooks
    place_knights
    place_bishops
    place_piece(translate([7, 3]), Queen.new('black'))
    place_piece(translate([0, 3]), Queen.new('white'))
    place_piece(translate([7, 4]), King.new('black'))
    place_piece(translate([0, 4]), King.new('white'))
  end

  def place_pawns(coordinates = [6, 0])
    return nil if coordinates[1] > 7

    place_piece(translate(coordinates), Pawn.new('black'))
    place_piece(translate(coordinates.add_array([-5, 0])), Pawn.new('white'))
    place_pawns(coordinates.add_array([0, 1]))
  end

  def place_rooks(coordinates = [7, 0])
    return nil if coordinates[1] > 7

    place_piece(translate(coordinates), Rook.new('black'))
    place_piece(translate(coordinates.add_array([-7, 0])), Rook.new('white'))
    place_rooks(coordinates.add_array([0, 7]))
  end

  def place_knights(coordinates = [7, 1])
    return nil if coordinates[1] > 7

    place_piece(translate(coordinates), Knight.new('black'))
    place_piece(translate(coordinates.add_array([-7, 0])), Knight.new('white'))
    place_knights(coordinates.add_array([0, 5]))
  end

  def place_bishops(coordinates = [7, 2])
    return nil if coordinates[1] > 7

    place_piece(translate(coordinates), Bishop.new('black'))
    place_piece(translate(coordinates.add_array([-7, 0])), Bishop.new('white'))
    place_bishops(coordinates.add_array([0, 3]))
  end

end
