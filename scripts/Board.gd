extends Node2D
class_name Board

signal lines_cleared(count: int)
signal no_lines_cleared
signal game_over

const WIDTH = 10
const HEIGHT = 20
const CELL_SIZE = 32

var grid = {} # Dictionary of Vector2i: Color
var clearing_lines = []
var clear_timer = 0.0
const CLEAR_ANIM_TIME = 0.3

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
	
	update_visuals()
	# Small delay before checking lines to let the piece "settle" visually
	get_tree().create_timer(0.1).timeout.connect(check_lines)

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
		start_clear_animation(lines_to_clear)
	else:
		no_lines_cleared.emit()

func start_clear_animation(lines: Array):
	clearing_lines = lines
	clear_timer = CLEAR_ANIM_TIME
	queue_redraw()

func _process(delta):
	if clear_timer > 0:
		clear_timer -= delta
		queue_redraw()
		if clear_timer <= 0:
			clear_timer = 0.0 # Clamp to zero
			var count = clearing_lines.size()
			# Sort and clear
			clearing_lines.sort()
			clear_lines(clearing_lines)
			clearing_lines = []
			lines_cleared.emit(count)

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
		cells_to_move.sort_custom(func(a, b): return a.y > b.y)
		
		for cell in cells_to_move:
			var color = grid[cell]
			grid.erase(cell)
			grid[Vector2i(cell.x, cell.y + 1)] = color

func update_visuals():
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
		if cell.y in clearing_lines:
			continue
		var color = grid[cell]
		var rect = Rect2(cell.x * CELL_SIZE, cell.y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
		draw_rect(rect, color)
		draw_rect(rect, color.darkened(0.5), false, 1.0)
	
	# Draw clearing animation (white flash)
	if clear_timer > 0:
		var alpha = clear_timer / CLEAR_ANIM_TIME
		for y in clearing_lines:
			for x in range(WIDTH):
				var rect = Rect2(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
				draw_rect(rect, Color(1, 1, 1, alpha))
