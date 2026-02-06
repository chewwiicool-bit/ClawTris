extends CanvasLayer

@onready var score_label = $Control/ScoreLabel
@onready var next_piece_container = $Control/NextPieceContainer

@onready var level_label = $Control/LevelLabel

const CELL_SIZE = 24 # Smaller size for preview

func _ready():
	get_parent().get_node("GameManager").score_changed.connect(_on_score_changed)
	get_parent().get_node("GameManager").level_changed.connect(_on_level_changed)
	get_parent().get_node("Spawner").next_piece_changed.connect(_on_next_piece_changed)

func _on_score_changed(new_score: int):
	score_label.text = "Score: " + str(new_score)

func _on_level_changed(new_level: int):
	level_label.text = "Level: " + str(new_level)

func _on_next_piece_changed(type: TetrominoData.Type):
	# Clear previous preview
	for child in next_piece_container.get_children():
		child.queue_free()
	
	var data = TetrominoData.DATA[type]
	var cells = data["cells"]
	var color = data["color"]
	
	var preview_node = Node2D.new()
	next_piece_container.add_child(preview_node)
	
	# Drawing simple blocks for preview
	for cell in cells:
		var rect = ColorRect.new()
		rect.size = Vector2(CELL_SIZE, CELL_SIZE)
		rect.position = Vector2(cell.x * CELL_SIZE, cell.y * CELL_SIZE)
		rect.color = color
		preview_node.add_child(rect)
