require './piece.rb'
require './board.rb'

class SteppingPiece < Piece

  def moves
    valid_moves = []

    move_dirs.each do |(dx, dy)|
      new_pos = [pos[0] + dx, pos[1] + dy]
      next unless Board.in_bounds?(new_pos)

      if board[new_pos].nil?
        valid_moves << new_pos
      elsif board[new_pos].color != self.color
        valid_moves << new_pos
      end
    end

    valid_moves.uniq
  end

end


class Knight < SteppingPiece

  def move_dirs
    [2,1,-1,-2].permutation(2).to_a.uniq
    .reject{ |(x,y)| x.abs == y.abs }
  end

  def to_s
    color == :w ? with_space('♘') : with_space('♞')
  end

end

class King < SteppingPiece

  def move_dirs
    [-1,1,-1,1].permutation(2).to_a.uniq +
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end

  def to_s
    color == :w ? with_space('♔') : with_space('♚')
  end

end
