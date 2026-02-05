extends "res://addons/gut/test.gd"

var SpawnerScript = load("res://scripts/Spawner.gd")
var ActivePieceScript = load("res://scripts/ActivePiece.gd")

func test_next_piece_preview():
	var spawner = SpawnerScript.new()
	# We need to mock the piece_scene because preload fails in unit tests if not handled
	spawner.piece_scene = load("res://scenes/Piece.tscn")
	spawner._ready()
	
	var first_next = spawner.next_piece_type
	assert_not_null(first_next, "Spawner should have a next piece type after ready")
	
	var spawned_piece = spawner.spawn()
	assert_eq(spawned_piece.type, first_next, "Spawned piece type should match the previewed type")
	
	var second_next = spawner.next_piece_type
	assert_ne(first_next, second_next, "Next piece type should update after spawn (highly likely with random bag)")
	
	spawned_piece.free()
	spawner.free()
