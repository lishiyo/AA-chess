class Board

  attr_accessor :grid

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
    enemy_pieces = pieces.select {|piece| piece.color != color }

    enemy_pieces.any? { |piece| piece.moves.include?(my_king(color).pos) }
  end

  def checkmate?(color)
    in_check?(color) && pieces.select { |piece| piece.color == color }
      .all? { |piece| piece.valid_moves.empty? }
  end

  def move(start_pos, end_pos)
    cause_check_moves = self[start_pos].moves - self[start_pos].valid_moves

    if cause_check_moves.include?(end_pos)
      raise ChessError.new("This move puts you in check!")
    end

    unless self[start_pos].moves.include?(end_pos)
      raise ChessError.new("This is not a possible move.")
    end

    move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)

    # delete piece at end_pos if it exists
    delete(end_pos) if self[end_pos]

    # move starting piece to end_pos
    self[end_pos] = self[start_pos]
    delete(start_pos)
    self[end_pos].pos = end_pos #updates piece's internal pos
    self[end_pos].has_moved = true
  end

  def castle_rook(color)
    my_rooks = pieces.select{|piece| piece.color == color && piece.class == Rook}
    king = my_king(color)
    closest_rook = my_rooks.min_by{ |rook| (king.pos[1] - rook.pos[1]).abs }

    if closest_rook.pos[1] == 0
      move!(closest_rook.pos, [closest_rook.pos[0], 3])
    else
      move!(closest_rook.pos, [closest_rook.pos[0], 5])
    end
  end

  # def inspect
  #   @grid.each do |row|
  #     p row.map { |el| [el.class, el.color] if el }
  #   end
  # end

  def can_castle?(color)
    return false if in_check?(color)
    
    king = my_king(color)
    rooks = pieces.select do |piece|
      piece.color == color && (piece.class == Rook)
    end


    if king.has_moved || rooks.all? { |rook| rook.has_moved }
      return false
    end

    can_castle_left?(color) || can_castle_right?(color)
  end

  def can_castle_left?(color)
    king = my_king(color)
    rooks = pieces.select do |piece|
      piece.color == color && (piece.class == Rook)
    end
    king_row = king.pos[0]

    spaces_between_left = (1 ... king.pos[1]).map do |col_i|
      [king_row, col_i]
    end

    if spaces_between_left.all? { |space| self[space].nil? }
      return spaces_between_left.none? { |space| king.move_into_check?(space) }
    end

    false
  end

  def can_castle_right?(color)
    king = my_king(color)
    rooks = pieces.select do |piece|
      piece.color == color && (piece.class == Rook)
    end
    king_row = king.pos[0]

    spaces_between_right = (king.pos[1]+1 ... 7).map do |col_i|
      [king_row, col_i]
    end

    if spaces_between_right.all?{ |space| self[space].nil? }
      return spaces_between_right.none? { |space| king.move_into_check?(space) }
    end

    false
  end

  def dup
    dup_board = Board.new

    @grid.each_with_index do |row, row_idx|
      row.each do |piece|
        unless piece.nil?
          piece.class.new(dup_board, piece.pos, piece.color)
        end
      end
    end

    dup_board
  end

  def display_board
		puts ""
    nums = "   ".concat(("a".."h").to_a.join("   "))
    top = " ┏" + "━" * 3 + ("┳" + "━" * 3) * 7 + "┓"
    bottom = " ┗" + "━" * 3 + ("┻" + "━" * 3) * 7 + "┛"
    middle = " ┣" + "━" * 3 + ("╋" + "━" * 3) * 7 + "┫"
    puts ""
    puts nums
    puts top
    @grid.each_with_index do |row, row_i|
      arr = ["#{(row_i-8).abs}"]
      row.each_with_index do |col, col_i|
        arr << self[[row_i, col_i]].to_s
      end
      puts arr.join("┃").concat("┃")# "  |  "
      puts middle unless row_i == @grid.count - 1
    end
    puts bottom
    nil
  end

  def pawn_at_ends?
    (grid[0] + grid[7]).any?{ |piece| piece.class == Pawn }
  end

  def promote_pawn(color)
    pawn = (grid[0] + grid[7]).detect{|piece| piece.class == Pawn }
    pawn_pos = pawn.pos
    delete(pawn_pos)
    self[pawn_pos] = Queen.new(self, pawn_pos, color)
  end

  protected

  def self.create_board
    Array.new(8) { Array.new(8, nil) }
  end

  private

  def delete(pos)
    self[pos] = nil
  end

  def my_king(color)
    pieces.detect do |piece|
      piece.class == King && piece.color == color
    end
  end

  def pieces
    @grid.flatten.reject{ |square| square.nil? }
  end

end
