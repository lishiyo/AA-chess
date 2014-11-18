class Board

  def initialize
    @grid = self.class.create_board
  end

  def self.in_bounds?(pos)
    x, y = pos[0], pos[1]
    x.between?(0, 7) && y.between?(0, 7)
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, mark)
    @grid[pos[0]][pos[1]] = mark
  end

  # find position of king, see if any enemy piece can move there
  def in_check?(color)

  end

  # king's list of valid moves is zero!
  def checkmate?(color)
  end

  # updates the @grid and also the moved piece's position
  # raise Exception if there is no piece at start_pos,
  # or if end_pos is not in piece's valid moves
  def move(start_pos, end_pos)
  end

  protected

  def self.create_board
    Array.new(8) { Array.new(8, nil) }
  end



end
