extends BattleMap

func _ready():
	ProjectSettings.set_setting("application/run/save_mission", "campaign_02")
	$ui_layer/dialog.load_script_file("res://src/dialogues/campaign_02.txt")
	next_level = "res://src/battle_map/campaign_03.tscn"
