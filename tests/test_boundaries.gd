extends "res://addons/gut/test.gd"

var BoardScript = load("res://scripts/Board.gd")

func test_boundary_top():
	var board = BoardScript.new()
	# Current implementation does NOT check y < 0
	var top_cell: Array[Vector2i] = [Vector2i(0, -1)]
	assert_true(board.is_position_valid(top_cell), "Top boundary is currently not checked (valid)")
	
	# If we want to restrict it, this should be assert_false
	board.free()
