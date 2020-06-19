extends Control

onready var portrait = $portrait
onready var name_label = $name_panel/Label
onready var text_label = $text_panel/Label

var scene_dict : Dictionary = {}
var current_line : int = -1

var dog_portrait = preload("res://assets/img/dog.png")
var bunny_portrait = preload("res://assets/img/bunny.png")
var fish_portrait = preload("res://assets/img/fish.png")
var nightmare_portrait = preload("res://assets/img/dog.png")


func _gui_input(event):
	if event is InputEventMouseButton:
		advance_dialogue()


# Load dialogue scene from given JSON file
func load_script_file(filepath):
	
	var file = File.new()
	if file.file_exists(filepath):
		file.open(filepath, 1)
		var parsed_json = JSON.parse(file.get_as_text())
		if parsed_json.error == OK:
			scene_dict = parsed_json.result
		else:
			print("Error: malformed JSON in %s" % filepath)
	else:
		print("Error: file %s not found" % filepath)


# Display text from next line of scene
func advance_dialogue():
	
	current_line += 1
	
	# If no more lines, remove this dialog window
	if current_line + 1 > len(scene_dict):
		visible = false
		queue_free()
	
	# Otherwise update the dialog text and portrait
	else:
		visible = true
		text_label.text = scene_dict[current_line]["text"]
		match scene_dict[current_line]["character"]:
			"dog":
				name_label.text = "Spot"
				portrait = dog_portrait
			"fish":
				name_label.text = "Goldie"
				portrait = fish_portrait
			"bunny":
				name_label.text = "Harry"
				portrait = bunny_portrait
			"nightmare":
				name_label.text = "Nightmare"
				portrait = nightmare_portrait
			_:
				print("Error: bad character string")
