extends "res://addons/gut/test.gd"

var BoardScript = load("res://scripts/Board.gd")

func test_is_position_valid():
	var board = BoardScript.new()
	# Empty board, valid positions
	var valid_cells: Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 1)]
	assert_true(board.is_position_valid(valid_cells), "Positions should be valid on empty board")
	
	# Out of bounds
	var out_left: Array[Vector2i] = [Vector2i(-1, 0)]
	assert_false(board.is_position_valid(out_left), "Out of bounds (left) should be invalid")
	
	var out_right: Array[Vector2i] = [Vector2i(10, 0)]
	assert_false(board.is_position_valid(out_right), "Out of bounds (right) should be invalid")
	
	var out_bottom: Array[Vector2i] = [Vector2i(0, 20)]
	assert_false(board.is_position_valid(out_bottom), "Out of bounds (bottom) should be invalid")
	
	# Occupied position
	board.grid[Vector2i(5, 5)] = Color.RED
	var occupied: Array[Vector2i] = [Vector2i(5, 5)]
	assert_false(board.is_position_valid(occupied), "Occupied position should be invalid")
	board.free()

func test_clear_lines():
	var board = BoardScript.new()
	# Fill bottom line (y = 19)
	for x in range(board.WIDTH):
		board.grid[Vector2i(x, board.HEIGHT - 1)] = Color.BLUE
	
	# Place one block above (y = 18)
	board.grid[Vector2i(0, board.HEIGHT - 2)] = Color.RED
	
	board.check_lines()
	board._process(0.5) # Wait for animation
	
	# The line was cleared AND then something moved into it. 
	# So grid.has(Vector2i(0, 19)) should be TRUE now because of the red block.
	# But wait, my first assertion was assert_false(board.grid.has(Vector2i(0, board.HEIGHT - 1)))
	# This fails because the red block ALREADY moved there.
	
	assert_eq(board.grid.size(), 1, "Only one block should remain")
	assert_true(board.grid.has(Vector2i(0, board.HEIGHT - 1)), "Block above should fall down")
	assert_eq(board.grid[Vector2i(0, board.HEIGHT - 1)], Color.RED, "Falling block should keep its color")
	board.free()

func test_clear_multiple_lines():
	var board = BoardScript.new()
	# Fill two bottom lines
	for x in range(board.WIDTH):
		board.grid[Vector2i(x, board.HEIGHT - 1)] = Color.BLUE
		board.grid[Vector2i(x, board.HEIGHT - 2)] = Color.GREEN
		
	board.check_lines()
	board._process(0.5) # Wait for animation
	assert_eq(board.grid.size(), 0, "Both lines should be cleared")
	board.free()
