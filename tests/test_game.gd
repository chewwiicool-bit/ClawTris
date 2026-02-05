extends "res://addons/gut/test.gd"

var BoardScript = load("res://scripts/Board.gd")

func test_game_over_detection():
	# Game Over logic is in GameManager.spawn_next
	# It checks if the new piece position is valid.
	# We can test the condition directly on the board.
	var board = BoardScript.new()
	
	# Fill the top row where pieces spawn
	# Spawn position is (5, 0) usually.
	board.grid[Vector2i(5, 0)] = Color.RED
	
	var piece_cells: Array[Vector2i] = [Vector2i(5, 0)]
	assert_false(board.is_position_valid(piece_cells), "Should detect collision at spawn point")
	
	board.free()
