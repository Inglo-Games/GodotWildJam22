extends PopupDialog


func _on_resume_btn_up():
	visible = false


func _on_quit_btn_up():
	get_tree().change_scene("res://src/menus/main_menu.tscn")
