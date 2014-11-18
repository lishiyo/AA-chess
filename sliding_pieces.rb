require './piece.rb'
require './board.rb'

class SlidingPiece < Piece

  def moves #make this pos match board class pos
    valid_moves = []
    deltas = move_dirs

    deltas.each do |(dx, dy)|
      new_pos = self.pos


      while Board.in_bounds?(new_pos)
        new_pos = [new_pos[0] + dx, new_pos[1] + dy]
        break unless Board.in_bounds?(new_pos)

        if board[new_pos].nil?
          valid_moves << new_pos
        elsif board[new_pos].color != self.color
          valid_moves << new_pos
          break
        elsif board[new_pos].color == self.color
          break
        end
      end

    end

    valid_moves.uniq
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