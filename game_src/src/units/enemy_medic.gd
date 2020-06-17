extends Unit
class_name EnemyMedic

func _ready():
	self.is_enemy = true
	self.move_range = 450.0
	self.attack_range = 800.0
	self.attack_dmg = 25.0
	self.armor = 0.7
