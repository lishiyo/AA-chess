require './board.rb'
require './piece.rb'
require './sliding_pieces.rb'
require './stepping_pieces.rb'

class InvalidMove < StandardError
end

class DangerOfCheck < InvalidMove
end

class Game

  attr_reader :board

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = Board.new
  end

  def setup_pieces
    @board.grid.each_with_index do |row, row_i|
      row.each_with_index do |col, col_j|
        pos = [row_i, col_j]
        rooks = Proc.new {|el| el == 7 || el == 0 }
        knights = Proc.new {|el| el == 6 || el == 1 }
        bishops = Proc.new {|el| el == 5 || el == 2 }
        case row_i
        when 0
          case col_j
          when rooks
            @board[pos] = Rook.new(@board, pos, :b)
          when knights
            @board[pos] = Knight.new(@board, pos, :b)
          when bishops
            @board[pos] = Bishop.new(@board, pos, :b)
          when 4
            @board[pos] = King.new(@board, pos, :b)
          when 3
            @board[pos] = Queen.new(@board, pos, :b)
          end
        when 1 # black pawns
          @board[pos] = Pawn.new(@board, pos, :b)
        when 6
          @board[pos] = Pawn.new(@board, pos, :w)
        when 7 # whites
          case col_j
          when rooks
            @board[pos] = Rook.new(@board, pos, :w)
          when knights
            @board[pos] = Knight.new(@board, pos, :w)
          when bishops
            @board[pos] = Bishop.new(@board, pos, :w)
          when 4
            @board[pos] = King.new(@board, pos, :w)
          when 3
            @board[pos] = Queen.new(@board, pos, :w)
          end
        end
      end
    end
  end


end
