extends Control

var tween = Tween.new()


func _ready():
	
	# Show outro dialogue
	$ui_layer/dialog.connect("dialogue_finished", self, "show_end_slide")
	$ui_layer/dialog.load_script_file("res://src/dialogues/outro.txt")


func show_end_slide():
	
	# Fade in outro quote
	add_child(tween)
	tween.interpolate_property($quote_bg, "modulate:a", 0.0, 1.0, 0.8, Tween.TRANS_LINEAR)
	tween.start()
	
	# Go back to menu
	yield(get_tree().create_timer(5.0), "timeout")
	get_tree().change_scene("res://src/menus/main_menu.tscn")
