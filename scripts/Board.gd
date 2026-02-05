extends Node2D
class_name Board

signal lines_cleared(count: int)
signal game_over

const WIDTH = 10
const HEIGHT = 20
const CELL_SIZE = 32

var grid = {} # Dictionary of Vector2i: Color

@onready var tile_map_layer = $TileMapLayer # Assuming we use TileMapLayer for display

func is_position_valid(cells: Array[Vector2i]) -> bool:
	for cell in cells:
		if cell.x < 0 or cell.x >= WIDTH or cell.y >= HEIGHT:
			return false
		if grid.has(cell):
			return false
	return true

func lock_piece(cells: Array[Vector2i], color: Color):
	for cell in cells:
		grid[cell] = color
	
	check_lines()
	update_visuals()

func check_lines():
	var lines_to_clear = []
	for y in range(HEIGHT):
		var full = true
		for x in range(WIDTH):
			if not grid.has(Vector2i(x, y)):
				full = false
				break
		if full:
			lines_to_clear.append(y)
	
	if lines_to_clear.size() > 0:
		# Important: clear from top to bottom if we shift things down line by line
		lines_to_clear.sort()
		clear_lines(lines_to_clear)
		lines_cleared.emit(lines_to_clear.size())

func clear_lines(lines: Array):
	for y in lines:
		# Remove the line
		for x in range(WIDTH):
			grid.erase(Vector2i(x, y))
		
		# Move everything above down
		var cells_to_move = []
		for cell in grid:
			if cell.y < y:
				cells_to_move.append(cell)
		
		# Move them down by one row
		# Sort by y descending to avoid overwriting during movement if not using temp storage
		cells_to_move.sort_custom(func(a, b): return a.y > b.y)
		
		for cell in cells_to_move:
			var color = grid[cell]
			grid.erase(cell)
			grid[Vector2i(cell.x, cell.y + 1)] = color

func update_visuals():
	# This would update TileMap or draw call
	queue_redraw()

func _draw():
	# Draw background
	draw_rect(Rect2(0, 0, WIDTH * CELL_SIZE, HEIGHT * CELL_SIZE), Color(0.1, 0.1, 0.1))
	
	# Draw grid lines
	for x in range(WIDTH + 1):
		draw_line(Vector2(x * CELL_SIZE, 0), Vector2(x * CELL_SIZE, HEIGHT * CELL_SIZE), Color(0.2, 0.2, 0.2), 1.0)
	for y in range(HEIGHT + 1):
		draw_line(Vector2(0, y * CELL_SIZE), Vector2(WIDTH * CELL_SIZE, y * CELL_SIZE), Color(0.2, 0.2, 0.2), 1.0)

	# Draw locked blocks
	for cell in grid:
		var color = grid[cell]
		var rect = Rect2(cell.x * CELL_SIZE, cell.y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
		draw_rect(rect, color)
		# Draw outline for blocks
		draw_rect(rect, color.darkened(0.5), false, 1.0)
