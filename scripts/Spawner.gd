extends Node2D
class_name Spawner

var active_piece: ActivePiece = null
var piece_scene = preload("res://scenes/Piece.tscn")

var bag = []

func _ready():
	refill_bag()

func refill_bag():
	bag = [
		TetrominoData.Type.I, TetrominoData.Type.J, TetrominoData.Type.L,
		TetrominoData.Type.O, TetrominoData.Type.S, TetrominoData.Type.T,
		TetrominoData.Type.Z
	]
	bag.shuffle()

func spawn() -> ActivePiece:
	if bag.size() == 0:
		refill_bag()
	
	var type = bag.pop_back()
	active_piece = piece_scene.instantiate()
	add_child(active_piece)
	active_piece.setup(type)
	return active_piece
