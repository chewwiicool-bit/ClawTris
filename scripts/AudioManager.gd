extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"
	
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	sfx_player.bus = "SFX"

func play_music(stream_path: String):
	var stream = load(stream_path)
	if stream:
		music_player.stream = stream
		music_player.play()

func play_sfx(sfx_name: String):
	# In a real project, we'd have a dictionary of sounds
	# For now, we'll try to load from assets/audio/sfx/
	var path = "res://assets/audio/sfx/" + sfx_name + ".wav"
	if FileAccess.file_exists(path):
		var stream = load(path)
		var p = AudioStreamPlayer.new()
		add_child(p)
		p.stream = stream
		p.bus = "SFX"
		p.play()
		p.finished.connect(p.queue_free)
	else:
		print("SFX not found: ", path)
