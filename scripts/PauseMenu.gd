extends Control

func _on_resume_button_pressed():
	get_parent().get_parent().resume_game() # GameManager is 2 levels up
	queue_free()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
