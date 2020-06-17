extends Unit
class_name EnemyInfantry

func _ready():
	self.is_enemy = true
	self.move_range = 500.0
	self.attack_range = 800.0
	self.attack_dmg = 80.0
	self.armor = 1.0
