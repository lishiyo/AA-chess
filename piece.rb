require './board.rb'

class Piece

  attr_reader :pos, :board, :color

  def initialize(board, pos, color) #[row,col]
    @board = board
    @pos = pos
    @color = color
  end

  # returns an array of places a Piece can move to
  def moves

  end



end



class Pawn < Piece

end
