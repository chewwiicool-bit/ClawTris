extends Node
class_name GameManager

enum State { START, PLAYING, PAUSED, GAMEOVER }

signal score_changed(new_score: int)

var current_state = State.START
var score = 0 :
	set(value):
		score = value
		score_changed.emit(score)
var level = 1

@onready var board = $"../Board"
@onready var spawner = $"../Spawner"
@onready var timer = $"../FallTimer"
@onready var ui_canvas = $"../UI"

var game_over_scene = preload("res://scenes/GameOverScreen.tscn")

func _ready():
	board.lines_cleared.connect(_on_lines_cleared)
	start_game()

func start_game():
	current_state = State.PLAYING
	score = 0
	level = 1
	spawn_next()
	timer.start()

func spawn_next():
	var piece = spawner.spawn()
	if not board.is_position_valid(piece.get_global_cells()):
		game_over()

func game_over():
	current_state = State.GAMEOVER
	timer.stop()
	var screen = game_over_scene.instantiate()
	ui_canvas.add_child(screen)
	screen.set_score(score)
	print("Game Over! Score: ", score)

func _on_lines_cleared(count: int):
	score += count * 100 * level
	print("Score: ", score)

func _on_fall_timer_timeout():
	if current_state == State.PLAYING:
		if not spawner.active_piece.move(Vector2i(0, 1)):
			board.lock_piece(spawner.active_piece.get_global_cells(), spawner.active_piece.color)
			spawner.active_piece.queue_free()
			spawn_next()

func _input(event):
	if current_state != State.PLAYING:
		if event.is_action_pressed("pause") and current_state == State.PAUSED:
			resume_game()
		return
	
	if event.is_action_pressed("move_left"):
		spawner.active_piece.move(Vector2i(-1, 0))
	elif event.is_action_pressed("move_right"):
		spawner.active_piece.move(Vector2i(1, 0))
	elif event.is_action_pressed("soft_drop"):
		_on_fall_timer_timeout()
	elif event.is_action_pressed("rotate"):
		spawner.active_piece.rotate_piece()
	elif event.is_action_pressed("hard_drop"):
		while spawner.active_piece.move(Vector2i(0, 1)):
			pass
		_on_fall_timer_timeout()
	elif event.is_action_pressed("pause"):
		pause_game()

func pause_game():
	current_state = State.PAUSED
	timer.stop()
	print("Game Paused")

func resume_game():
	current_state = State.PLAYING
	timer.start()
	print("Game Resumed")
