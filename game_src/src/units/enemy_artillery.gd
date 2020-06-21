extends Unit
class_name EnemyArtillery

func _ready():
	self.is_enemy = true
	self.move_range = 350.0
	self.attack_range = 2500.0
	self.armor = 0.5
