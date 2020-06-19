extends BattleMap

func _ready():
	$ui_layer/dialog.load_script_file("res://src/dialogues/tutorial_01.txt")
	next_level = "res://src/battle_map/tutorial_02.tscn"
