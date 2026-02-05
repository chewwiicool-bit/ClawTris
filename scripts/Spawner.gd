extends Node2D
class_name Spawner

var active_piece: ActivePiece = null
var next_piece_type: TetrominoData.Type
var piece_scene = preload("res://scenes/Piece.tscn")

var bag = []

func _ready():
	refill_bag()
	# Pick the first "next" piece
	next_piece_type = bag.pop_back()

func refill_bag():
	bag = [
		TetrominoData.Type.I, TetrominoData.Type.J, TetrominoData.Type.L,
		TetrominoData.Type.O, TetrominoData.Type.S, TetrominoData.Type.T,
		TetrominoData.Type.Z
	]
	bag.shuffle()

func spawn() -> ActivePiece:
	active_piece = piece_scene.instantiate()
	add_child(active_piece)
	active_piece.setup(next_piece_type)
	
	# Prepare next piece
	if bag.size() == 0:
		refill_bag()
	next_piece_type = bag.pop_back()
	
	return active_piece
