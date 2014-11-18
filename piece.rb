require './board.rb'

class Piece

  attr_reader :board
  attr_accessor :pos, :color

  def initialize(board, pos, color) #[row,col]
    @board = board
    @pos = pos
    @color = color
  end

  # returns an array of places a Piece can move to
  def moves

  end

  # filters out the moves of a Piece that would leave the player in check
  def valid_moves

  end

  def move_into_check?(pos)

  end

  def inspect
      [@pos, @color]
  end


end



class Pawn < Piece

  def moves
    valid_moves = []

    deltas = {
      :b => [[1, 0],[1, -1],[1, 1]],
      :w => [[-1,0],[-1,-1],[-1,1]]
    }

    deltas[color].each_with_index do |(dx, dy), idx|
      new_pos = pos

      new_pos = [new_pos[0] + dx, new_pos[1] + dy]
      next unless Board.in_bounds?(new_pos)

      case idx
      when 0
        valid_moves << new_pos if board[new_pos].nil?
      else
        if board[new_pos] && board[new_pos].color != self.color
          valid_moves << new_pos
        end
      end
    end
    valid_moves.uniq
  end
end
