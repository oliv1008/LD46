extends Control

var RED = Color(255, 0, 0, 255)
var YELLOW = Color(255, 127, 0)
var GREEN = Color(0, 255, 0)

var user
var alive = true 

func init(monster):
	user = monster

func _physics_process(delta):
	if alive == true:
		$"hp".rect_size.x = user.hp
		if user.hp >= 66:
			$"hp".color = GREEN
		if user.hp < 66 && user.hp > 33:
			$"hp".color = YELLOW
		if user.hp <= 33:
			$"hp".color = RED
		if user.hp <= 0:
			alive = false
