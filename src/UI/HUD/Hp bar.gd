extends Control

var RED = Color(255, 0, 0, 255)
var YELLOW = Color(255, 127, 0)
var GREEN = Color(0, 255, 0)

func _physics_process(delta):
	$"hp".rect_size.x = owner.hp
	if owner.hp >= 66:
		$"hp".color = GREEN
	if owner.hp < 66 && owner.hp > 33:
		$"hp".color = YELLOW
	if owner.hp <= 33:
		$"hp".color = RED
	Color()
	
