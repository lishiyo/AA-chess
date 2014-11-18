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

  protected

  def self.create_board
    Array.new(8) { Array.new(8, nil) }
  end

end
