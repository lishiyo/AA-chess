require './piece.rb'

class SlidingPiece < Piece

  def initialize
  end

  def moves
    
  end
end


class Bishop < SlidingPiece

  def move_dirs
    [-1,1,-1,1].permutation(2).to_a.uniq
  end

end

class Rook < SlidingPiece

  def move_dirs
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end

class Queen < SlidingPiece

  def move_dirs
    [-1,1,-1,1].permutation(2).to_a.uniq +
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end

end
