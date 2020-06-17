extends Unit
class_name EnemyArmored

func _ready():
	self.is_enemy = true
	self.move_range = 1200.0
	self.attack_range = 800.0
	self.attack_dmg = 100.0
	self.armor = 2.5
