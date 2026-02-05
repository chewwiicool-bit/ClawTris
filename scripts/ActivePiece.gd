extends Node2D
class_name ActivePiece

var type: TetrominoData.Type
var cells: Array[Vector2i]
var color: Color
var board_pos: Vector2i = Vector2i(5, 0)

const CELL_SIZE = 32

func setup(t_type: TetrominoData.Type):
	type = t_type
	var data = TetrominoData.DATA[type]
	cells.clear()
	for cell in data["cells"]:
		cells.append(cell)
	color = data["color"]
	board_pos = Vector2i(Board.WIDTH / 2, 0) if get_parent().has_method("get_board") else Vector2i(5, 0)

func get_global_cells() -> Array[Vector2i]:
	var global_cells: Array[Vector2i] = []
	for cell in cells:
		global_cells.append(cell + board_pos)
	return global_cells

func move(dir: Vector2i) -> bool:
	var new_pos = board_pos + dir
	var new_cells: Array[Vector2i] = []
	for cell in cells:
		new_cells.append(cell + new_pos)
	
	if get_parent().board.is_position_valid(new_cells):
		board_pos = new_pos
		queue_redraw()
		return true
	return false

func rotate_piece():
	var new_cells: Array[Vector2i] = []
	for cell in cells:
		# Standard 90 deg rotation: (x, y) -> (-y, x)
		new_cells.append(Vector2i(-cell.y, cell.x))
	
	var global_new_cells: Array[Vector2i] = []
	for cell in new_cells:
		global_new_cells.append(cell + board_pos)
	
	if get_parent().board.is_position_valid(global_new_cells):
		cells = new_cells
		queue_redraw()

func _draw():
	for cell in cells:
		var rect = Rect2(cell.x * CELL_SIZE, cell.y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
		draw_rect(rect, color)
		draw_rect(rect, color.darkened(0.5), false, 1.0)
	
	# Optional: draw local origin for debugging
	# draw_circle(Vector2.ZERO, 2, Color.WHITE)

func _process(_delta):
	position = Vector2(board_pos.x * CELL_SIZE, board_pos.y * CELL_SIZE)
