extends BattleMap

func _ready():
	$ui_layer/dialog.load_script_file("res://src/dialogues/tutorial_02.txt")
	next_level = "res://src/battle_map/campaign_01.tscn"
