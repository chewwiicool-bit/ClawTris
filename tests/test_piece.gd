extends "res://addons/gut/test.gd"

var ActivePieceScript = load("res://scripts/ActivePiece.gd")
var BoardScript = load("res://scripts/Board.gd")

class MockBoardParent:
	extends Node2D
	var board
	func _init(b):
		board = b

func test_movement():
	var board = BoardScript.new()
	var parent = MockBoardParent.new(board)
	var piece = ActivePieceScript.new()
	parent.add_child(piece)
	
	piece.setup(TetrominoData.Type.O)
	var start_pos = piece.board_pos
	
	assert_true(piece.move(Vector2i(1, 0)), "Should move right")
	assert_eq(piece.board_pos, start_pos + Vector2i(1, 0))
	
	# Block movement by boundary
	piece.board_pos = Vector2i(board.WIDTH - 2, 0) # O piece is 2x2
	assert_false(piece.move(Vector2i(1, 0)), "Should not move out of bounds")
	
	piece.free()
	parent.free()
	board.free()

func test_rotation():
	var board = BoardScript.new()
	var parent = MockBoardParent.new(board)
	var piece = ActivePieceScript.new()
	parent.add_child(piece)
	
	piece.setup(TetrominoData.Type.T)
	# T piece initial: (0, -1), (-1, 0), (0, 0), (1, 0)
	var initial_cells = piece.cells.duplicate()
	piece.rotate_piece()
	# Rotate 90 deg: (x, y) -> (-y, x)
	# (0, -1) -> (1, 0)
	# (-1, 0) -> (0, -1)
	# (0, 0) -> (0, 0)
	# (1, 0) -> (0, 1)
	assert_has(piece.cells, Vector2i(1, 0))
	assert_has(piece.cells, Vector2i(0, -1))
	assert_has(piece.cells, Vector2i(0, 0))
	assert_has(piece.cells, Vector2i(0, 1))
	
	piece.free()
	parent.free()
	board.free()
