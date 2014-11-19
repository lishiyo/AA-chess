require './board.rb'
require './piece.rb'
require './sliding_pieces.rb'
require './stepping_pieces.rb'

require 'yaml'

class ChessError < StandardError
end

class Game

  attr_reader :board

  def initialize(player1 = HumanPlayer.new, player2 = HumanPlayer.new)
    @player1 = player1
    @player2 = player2

    setup_game
  end

  def play_game
    @board.display_board

    until over?
      @current_player = switch_player

      if @board.in_check?(switch_player.color)
        puts "#{switch_player.color} is in check!"
      end

      play_round

      @board.display_board
      raw_start, raw_end = @current_player.raw_input
      puts "#{@current_player.to_s} moved from #{raw_start} to #{raw_end}."
    end

    puts "Checkmate! #{@current_player.to_s} wins!"
  end

  private

  def play_round
    begin
      player_move = @current_player.get_player_move # returns [[0,1], [1,2]]
      case player_move
      when "save"
        save_game
        exit
      else
        start_pos, end_pos = player_move
      end

      raise ChessError.new("Empty starting position!") unless @board[start_pos]

      if @board[start_pos].color != @current_player.color
        raise ChessError.new("That's not your color!")
      end
      @board.move(start_pos, end_pos) # throws DangerOfCheck or InvalidMove
    rescue ChessError => e
      @current_player.handle_move_response(e)
      retry
    end
  end

  def over?
    @board.checkmate?(switch_player.color)
  end

  def switch_player
    @current_player == @player2 ? @player1 : @player2
  end

  def setup_game
    @board = Board.new
    setup_pieces
    setup_players
  end

  def setup_players
    @current_player = @player2
    @player1.color = :w
    @player2.color = :b
  end

  def setup_pieces
    order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    @board.grid.each_with_index do |row, row_i|
      order.each_with_index do |piece_type, col_j|
        pos = [row_i, col_j]
        case row_i
        when 0
          piece_type.new(@board, pos, :b)
        when 1
          Pawn.new(@board, pos, :b)
        when 6
          Pawn.new(@board, pos, :w)
        when 7
          piece_type.new(@board, pos, :w)
        end
      end
    end
  end

  def save_game
    @current_player = switch_player
    puts "Enter a filename for your saved game:"
    filename = gets.chomp

    File.write(filename, YAML.dump(self))
  end
end

class Player

  COLORS = {
    :b => "Black",
    :w => "White"
  }

  attr_accessor :color

  def to_s
    COLORS[color]
  end

end

class HumanPlayer < Player

  attr_reader :raw_input

  def get_player_move

    puts "Make your move! For example, type in f2, f3. Or type 'save' to save and quit."
    player_input = gets.chomp

    if player_input == "save"
      return "save"
    else
      @raw_input = player_input.delete(" ").split(",")

      unless raw_input.all?{|coord| coord =~ /^[a-h][1-8]$/ }
        raise ChessError.new("Not valid input!")
      end

      start_pos, end_pos = raw_input.map do |coord|
        [translate_number(coord[1]), translate_letter(coord[0])]
      end

      [start_pos, end_pos]
    end
  end

  def handle_move_response(e)
    puts e.message
  end

  private

  def translate_letter(letter)
    ("a".."h").to_a.index(letter)
  end

  def translate_number(num)
    (num.to_i-8).abs
  end

end


if __FILE__ == $PROGRAM_NAME
  # ruby game.rb saved-game.yaml
  case ARGV.size
  when 1 then YAML.load_file(ARGV.shift).play_game
  when 0 then Game.new.play_game
  end
end
