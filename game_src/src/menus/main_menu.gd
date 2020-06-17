extends Control


func _on_start_button_up():
	get_tree().change_scene("res://src/battle_map/battle_map.tscn")


func _on_quit_button_up():
	get_tree().quit()
