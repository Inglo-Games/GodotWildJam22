extends Control

var player_turn : bool = true
var selected_unit : Unit = null

onready var move_marker = $range_markers/move_range
onready var attack_marker = $range_markers/attack_range


func _ready():
	
	# Connect units to relevant callback functions
	for unit in $player_units.get_children():
		unit.connect("unit_selected", self, "_on_unit_selected")
	for unit in $enemy_units.get_children():
		unit.connect("unit_selected", self, "_on_enemy_selected")


# Get input on battle map
func _gui_input(event):
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		print("Got click...")
		
		# Handle unit movement
		if player_turn and selected_unit != null:
			print("Unit selected...")
			
			var dist = event.global_position.distance_to(selected_unit.rect_global_position)
			if selected_unit.can_move and dist <= selected_unit.move_range:
				selected_unit.rect_global_position = event.global_position
				selected_unit.unit_moved()
				draw_range_markers()


# React to player clicking on own unit
func _on_unit_selected(unit):
	
	if selected_unit != null:
		
		var dist = selected_unit.rect_global_position.distance_to(unit.rect_global_position)
		
		# Case 1: User is trying to heal unit with medic
		if selected_unit is Medic and dist <= selected_unit.attack_range and selected_unit.can_attack:
			selected_unit.can_attack = false
			attack_marker.visible = false
			unit.health = 100.0
		
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
	
	draw_range_markers()


# Reset player's unit moves and trigger AI turn
func _on_end_turn_btn_up():
	player_turn = false
	selected_unit = null
	move_marker.visible = false
	attack_marker.visible = false
	exec_ai_turn()
	for unit in $player_units.get_children():
		unit.reset_move_and_attack()


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
	for unit in $enemy_units.get_children():
		# TODO: Implement enemy AI
		pass
	
	player_turn = true
