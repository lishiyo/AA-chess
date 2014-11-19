game = Game.new(1,2)
game.setup_pieces
b = game.board
b.move([6,5],[5,5])
b.move([1,4],[3,4])
b.move([6,6],[4,6])
b.move([0,3],[4,7])
