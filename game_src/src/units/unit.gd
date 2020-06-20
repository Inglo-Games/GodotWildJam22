extends Control
class_name Unit

signal unit_selected
signal unit_killed

# Unit stats
var is_enemy : bool = false
var move_range : float = 500.0
var attack_range : float = 300.0
var attack_dmg : float = 50.0
var armor : float = 1.0

# Instace vars
var health : float = 100.0
var can_attack : bool = true
var can_move : bool = true


func _gui_input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_LEFT):
		emit_signal("unit_selected", self)


# Deal damage to another unit
func attack_unit(enemy):
	if can_attack:
		var health_scaling = max(health / 100.0, 0.2)
		enemy.damage_received(attack_dmg * health_scaling)
		can_attack = false
		check_move_and_attack()


# Calculate damage taken, update health bar, check if unit is still alive
func damage_received(damage):
	health -= damage / armor
	$vbox/health_bar.value = health
	if health <= 0:
		emit_signal("unit_killed", self)


# Called after a player moves this unit
func unit_moved():
	can_move = false
	check_move_and_attack()


func check_move_and_attack():
	if not(can_move or can_attack):
		modulate = Color("3d3d3d")


# Called on a new turn, resets move indicator
func reset_move_and_attack():
	can_attack = true
	can_move = true
	modulate = Color("ffffff")
