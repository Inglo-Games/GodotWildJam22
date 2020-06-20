extends Control

var mission = ""

func _ready():
	mission = ProjectSettings.get_setting("application/run/save_mission")
	if mission != "none":
		$vbox/load_btn.disabled = false


func _on_start_button_up():
	get_tree().change_scene("res://src/battle_map/tutorial_01.tscn")


func _on_load_btn_up():
	var new_scene = "res://src/battle_map/battle_map.tscn"
	match mission:
		"tutorial_01": new_scene = "res://src/battle_map/tutorial_01.tscn"
		"tutorial_02": new_scene = "res://src/battle_map/tutorial_02.tscn"
	
	get_tree().change_scene(new_scene)


func _on_opts_btn_up():
	pass # Replace with function body.


func _on_cred_btn_up():
	pass # Replace with function body.


func _on_quit_button_up():
	get_tree().quit()
