extends BattleMap

func _ready():
	ProjectSettings.set_setting("application/run/save_mission", "campaign_04")
	$ui_layer/dialog.load_script_file("res://src/dialogues/campaign_04.txt")
	next_level = "res://src/battle_map/campaign_05.tscn"
