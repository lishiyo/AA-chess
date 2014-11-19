require './board.rb'

class Piece

  attr_reader :board
  attr_accessor :pos, :color

  def initialize(board, pos, color) #[row,col]
    @board = board
    @pos = pos
    @color = color
    @board[pos] = self
  end

  # filters out the moves of a Piece that would leave the player in check
  def valid_moves
    moves.reject{ |pos| move_into_check?(pos) }
  end

  def move_into_check?(end_pos)
    duped_board = @board.dup
    duped_board.move!(self.pos, end_pos)
    duped_board.in_check?(self.color)
  end

  def inspect
      [@pos, @color]
  end

  protected

  def with_space(char)
    " #{char} "
  end

end



class Pawn < Piece

  def moves
    valid_moves = []

    deltas = {
      :b => [[1, 0],[2, 0],[1, -1],[1, 1]],
      :w => [[-1,0],[-2, 0],[-1,-1],[-1,1]]
    }

    deltas[color].each_with_index do |(dx, dy), idx|
      new_pos = [pos[0] + dx, pos[1] + dy]
      next unless Board.in_bounds?(new_pos)

      case idx
      when 0
        valid_moves << new_pos if board[new_pos].nil?
      when 1
        valid_moves << new_pos if board[new_pos].nil? && color == :b && pos[0] == 1
        valid_moves << new_pos if board[new_pos].nil? && color == :w && pos[0] == 6
      else
        if board[new_pos] && board[new_pos].color != self.color
          valid_moves << new_pos
        end
      end
    end
    valid_moves.uniq
  end

  def to_s
    color == :w ? with_space('♙') : with_space('♟')
  end

end


class NilClass

  def to_s
    "   "
  end

end
