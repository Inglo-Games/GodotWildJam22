extends Control

var tween = Tween.new()


func _ready():
	
	BGM.play_audio()
	
	# Fade out intro quote
	add_child(tween)
	tween.interpolate_property($quote_bg, "modulate:a", 1.0, 0.0, 0.8, Tween.TRANS_LINEAR)
	yield(get_tree().create_timer(8.0), "timeout")
	tween.start()
	yield(tween, "tween_all_completed")
	
	# Show intro dialogue
	$ui_layer/dialog.connect("dialogue_finished", self, "advance_to_level")
	$ui_layer/dialog.load_script_file("res://src/dialogues/intro.txt")


func advance_to_level():
	 get_tree().change_scene("res://src/battle_map/tutorial_01.tscn")
