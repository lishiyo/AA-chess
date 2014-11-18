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

  def initialize(player1 = HumanPlayer.new, player2 = HumanPlayer.new)
    @player1 = player1
    @player2 = player2
    @board = Board.new
    setup_pieces
    setup_players
  end

  def play_game
    over = false
    player = @player2
    until over
      player = player == @player2 ? @player1 : @player2
      player_input = get_player_move(player) #write this tomorrow plz
      start_loc, end_loc = player_input.split(",").map do |coord|
        [translate_letter(coord[0]), translate_number(coord[1])]
      end
    end
  end

  def setup_players
    @player1.color = :w
    @player2.color = :b
  end

  def translate_letter(letter)
    ("a".."h").to_a.index(letter)
  end

  def translate_number(num)
    (num.to_i-8).abs
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

class HumanPlayer
  attr_accessor :color

  def initialize
  end
end
