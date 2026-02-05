extends "res://addons/gut/test.gd"

var BoardScript = load("res://scripts/Board.gd")

func test_line_clear_delay():
	var board = BoardScript.new()
	# Set up a full line
	for x in range(board.WIDTH):
		board.grid[Vector2i(x, board.HEIGHT - 1)] = Color.BLUE
	
	board.check_lines()
	
	# After check_lines, the line should still exist because of the animation timer
	assert_eq(board.grid.size(), board.WIDTH, "Line should still be in grid during animation")
	assert_gt(board.clear_timer, 0, "Animation timer should be active")
	
	# Simulate time passing
	board._process(board.CLEAR_ANIM_TIME + 0.1)
	
	assert_eq(board.grid.size(), 0, "Line should be cleared after animation finishes")
	assert_almost_eq(board.clear_timer, 0.0, 0.01, "Animation timer should be reset")
	
	board.free()

func test_piece_spawns_during_animation():
	# In current GameManager.gd:
	# lock_piece -> check_lines -> start_clear_animation
	# then GameManager calls spawn_next() IMMEDIATELY after lock_piece
	# This means a new piece starts falling WHILE the line is still visually there
	# and WHILE the line is still in the grid dictionary.
	
	var board = BoardScript.new()
	# Fill almost everything to make it tight
	for x in range(board.WIDTH):
		board.grid[Vector2i(x, 1)] = Color.RED # Line 1 is full
		
	# A piece locks at line 0, which triggers clear of line 1 (if we had logic for that)
	# But more importantly, if line 0 is full, spawn_next might fail because 
	# the line hasn't been removed from 'grid' yet.
	
	# Let's test the specific case: 
	# 1. Fill line 0 (spawn line)
	# 2. Trigger check_lines
	# 3. Try to validate spawn position (it should FAIL if line 0 is still in grid)
	
	for x in range(board.WIDTH):
		board.grid[Vector2i(x, 0)] = Color.GREEN
		
	board.check_lines() # Line 0 is now 'clearing'
	
	var spawn_cells: Array[Vector2i] = [Vector2i(5, 0)]
	assert_false(board.is_position_valid(spawn_cells), "Spawn position is INVALID while line 0 is animating clear")
	
	board.free()
