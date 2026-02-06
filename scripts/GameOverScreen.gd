extends Control

@onready var score_label = $CenterContainer/VBoxContainer/ScoreLabel

func set_score(score: int):
	score_label.text = "Final Score: " + str(score)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
