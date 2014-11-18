require './piece.rb'

class SteppingPiece < Piece

end


class Knight < SteppingPiece

  def move_dirs
    [2,1,-1,-2].permutation(2).to_a.uniq
    .reject{ |(x,y)| x.abs == y.abs }
  end

end

class King < SteppingPiece

  def move_dirs
    [-1,1,-1,1].permutation(2).to_a.uniq +
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end
