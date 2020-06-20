extends BattleMap

func _ready():
	ProjectSettings.set_setting("application/run/save_mission", "tutorial_02")
	$ui_layer/dialog.load_script_file("res://src/dialogues/tutorial_02.txt")
	next_level = "res://src/battle_map/campaign_01.tscn"
