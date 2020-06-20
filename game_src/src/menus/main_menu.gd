extends Control

var mission = ""

func _ready():
	mission = "res://src/battle_map/%s.tscn" % ProjectSettings.get_setting("application/run/save_mission")
	
	var file = File.new()
	if file.file_exists(mission):
		$vbox/load_btn.disabled = false


func _on_start_button_up():
	get_tree().change_scene("res://src/cutscenes/intro_scene.tscn")


func _on_load_btn_up():
	get_tree().change_scene(mission)


func _on_opts_btn_up():
	pass # Replace with function body.


func _on_cred_btn_up():
	pass # Replace with function body.


func _on_quit_button_up():
	get_tree().quit()
