extends BattleMap

func _ready():
	ProjectSettings.set_setting("application/run/save_mission", "campaign_05")
	$ui_layer/dialog.load_script_file("res://src/dialogues/campaign_05.txt")
	next_level = "res://src/cutscenes/outro_scene.tscn"
