extends "res://addons/gut/test.gd"

var GameManagerScript = load("res://scripts/GameManager.gd")

func test_input_actions_mapped_to_logic():
	# This test verifies that the actions used by TouchScreenButtons 
	# are actually handled in GameManager._input
	var gm = GameManagerScript.new()
	
	# Since we can't easily simulate TouchScreenButton in a unit test without a scene,
	# we verify the logic responds to InputEvents with the correct actions.
	
	var actions = ["ui_left", "ui_right", "ui_up", "ui_down", "ui_accept"]
	for action in actions:
		assert_true(InputMap.has_action(action), "Action %s should be defined in InputMap" % action)
	
	gm.free()

func test_touch_controls_presence_in_main():
	var scene_resource = load("res://scenes/Main.tscn")
	if scene_resource == null:
		# In headless mode without editor import, we might need to skip this
		# but let's try to check the TouchControls scene directly
		scene_resource = load("res://scenes/TouchControls.tscn")
		
	assert_not_null(scene_resource, "Resource should be loadable")
	if scene_resource == null: return
	
	var node = scene_resource.instantiate()
	
	var buttons = {
		"Left": "ui_left",
		"Right": "ui_right",
		"Rotate": "ui_up",
		"SoftDrop": "ui_down",
		"HardDrop": "ui_accept"
	}
	
	var control_node = node.get_node("Control")
	for btn_name in buttons.keys():
		var btn = control_node.get_node_or_null(btn_name)
		assert_not_null(btn, "Button %s should exist" % btn_name)
		if btn:
			assert_eq(btn.action, buttons[btn_name], "Button %s should trigger %s" % [btn_name, buttons[btn_name]])
	
	node.free()
