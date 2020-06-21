extends Unit
class_name EnemyArmored

func _ready():
	self.is_enemy = true
	self.move_range = 900.0
	self.attack_range = 600.0
	self.attack_dmg = 80.0
	self.armor = 1.8
