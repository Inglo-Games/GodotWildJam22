class_name BattleMap
extends Control

const ai_action_wait_time : float = 0.3		# Time to wait between AI moves

var next_level : String = ""

var player_turn : bool = true
var selected_unit : Unit = null

onready var move_marker = $range_markers/move_range
onready var attack_marker = $range_markers/attack_range

onready var enemy_units = $enemy_units
onready var player_units = $player_units


func _ready():
	
	# Connect units to relevant callback functions
	for unit in $player_units.get_children():
		unit.connect("unit_selected", self, "_on_unit_selected")
		unit.connect("unit_killed", self, "_on_unit_killed")
	for unit in $enemy_units.get_children():
		unit.connect("unit_selected", self, "_on_enemy_selected")
		unit.connect("unit_killed", self, "_on_unit_killed")
	
	$bg.connect("gui_input", self, "map_input")
	
	$ui_layer/dialog.load_script_file("res://src/dialogues/intro.txt")


# Get input on battle map
func map_input(event):
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
	
		# Handle unit movement
		if player_turn and selected_unit != null:
			
			var dist = event.position.distance_to(selected_unit.rect_position)
			if selected_unit.can_move and dist <= selected_unit.move_range:
				selected_unit.rect_position = event.position
				selected_unit.unit_moved()
				draw_range_markers()


# React to player clicking on own unit
func _on_unit_selected(unit):
	
	if selected_unit != null:
		
		var dist = selected_unit.rect_global_position.distance_to(unit.rect_global_position)
		
		# Case 1: User is trying to heal unit with medic
		if selected_unit is Medic and dist <= selected_unit.attack_range and selected_unit.can_attack:
			selected_unit.can_attack = false
			selected_unit.check_move_and_attack()
			selected_unit.get_node("heal_sound").play()
			attack_marker.visible = false
			unit.health = 100.0
			unit.get_node("vbox/health_bar").value = 100.0
		
		# Case 2: User is selecting unit
		else:
			selected_unit = unit
	
	else:
		selected_unit = unit
		
	draw_range_markers()


# React to player clicking on enemy unit
func _on_enemy_selected(unit):
	if player_turn and selected_unit != null:
		var dist = selected_unit.rect_global_position.distance_to(unit.rect_global_position)
		if dist <= selected_unit.attack_range and selected_unit.can_attack: 
			selected_unit.attack_unit(unit)


# Check to see if there are no enemy or player units left
func _on_unit_killed(unit):
	
	unit.queue_free()
	
	if $player_units.get_child_count() == 1 and not unit.is_enemy: 
		player_lost()
	elif $enemy_units.get_child_count() == 1 and unit.is_enemy:
		player_won()


# Reset player's unit moves and trigger AI turn
func _on_end_turn_btn_up():
	
	player_turn = false
	selected_unit = null
	move_marker.visible = false
	attack_marker.visible = false
	
	exec_ai_turn()
	
	for unit in $player_units.get_children():
		unit.reset_move_and_attack()
	player_turn = true


# Show pause menu
func _on_pause_btn_up():
	$ui_layer/pause_popup.popup_centered()


# Size and place markers showing player the move and attack ranges for the
# selected unit
func draw_range_markers():
	
	move_marker.rect_size = Vector2.ONE * selected_unit.move_range * 2
	move_marker.rect_global_position = selected_unit.rect_global_position - move_marker.rect_size / 2.0
	move_marker.visible = selected_unit.can_move
	
	attack_marker.rect_size = Vector2.ONE * selected_unit.attack_range * 2
	attack_marker.rect_global_position = selected_unit.rect_global_position - attack_marker.rect_size / 2.0
	attack_marker.visible = selected_unit.can_attack


func exec_ai_turn():
	
	# Calculate center point of each army
	var enemy_center = average_pos(enemy_units.get_children())
	var player_center = average_pos(player_units.get_children())
	
	# Process move for each enemy unit
	for unit in enemy_units.get_children():
	
		var unit_pos = unit.rect_global_position
		
		if player_units.get_child_count() > 0:
					
			# Move toward center of player army, plus a small randomized amount
			# to help prevent a stack
			var loc = unit.rect_global_position.direction_to(player_center) * unit.move_range + \
						Vector2(randf() * 300.0, 0).rotated(randf() * 2 * PI)
			unit.rect_global_position += loc
			
			# Determine which units are in range, are weakened, and are infantry
			var player_units_in_range = []
			var weak_units_in_range = []
			var infantry_in_range = []
			
			for target in player_units.get_children():
				if target.rect_global_position.distance_to(unit_pos) <= unit.attack_range:
					player_units_in_range.append(target)
					if target.health < 100.0:
						weak_units_in_range.append(target)
					if target is Infantry:
						infantry_in_range.append(target)
			
			# If units in range...
			if len(player_units_in_range) > 0:
				
				# Prioritize attacking weakest ones first
				if len(weak_units_in_range) > 0:
					var weakest = weak_units_in_range[0]
					for target in weak_units_in_range:
						if target.health < weakest.health:
							weakest = target
					unit.attack_unit(weakest)
				
				# Next prioritize infantry units
				elif len(infantry_in_range) > 0:
					unit.attack_unit(infantry_in_range[0])
				
				# Otherwise attack anything
				else:
					unit.attack_unit(player_units_in_range[0])
	
	# Reset move and attack flags for next round
	for unit in enemy_units.get_children():
		unit.reset_move_and_attack()


# Find the center point of a group of units
func average_pos(units):
	var avg_x := 0.0
	var avg_y := 0.0
	for unit in units:
		avg_x += unit.rect_global_position.x
		avg_y += unit.rect_global_position.y
	avg_x /= float(len(units))
	avg_y /= float(len(units))
	return Vector2(avg_x, avg_y)


# Show a popup that advances to next level
func player_won():
	
	# Create a popup and display it
	var popup = $ui_layer/win_popup
	popup.get_node("vbox/btn").connect("pressed", self, "load_next_level")
	popup.popup_centered()


# Show a popup message that returns to main menu
func player_lost():
	
	# Create a popup and display it
	var popup = $ui_layer/loss_popup
	popup.get_node("vbox/btn").connect("pressed", self, "return_to_menu")
	popup.popup_centered()


func load_next_level():
	var level_file = File.new()
	if level_file.file_exists(next_level):
		get_tree().change_scene(next_level)
	else:
		get_tree().change_scene("res://src/menus/main_menu.tscn")


func return_to_menu():
	get_tree().change_scene("res://src/menus/main_menu.tscn")


