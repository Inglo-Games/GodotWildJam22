extends Unit
class_name Artillery

func _ready():
	self.move_range = 250.0
	self.attack_range = 5000.0
	self.attack_dmg = 80.0
	self.armor = 0.5
