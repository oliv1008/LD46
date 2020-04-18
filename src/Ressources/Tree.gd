extends Node2D

var user
var previous_user
var activated = false
var is_generating = false
var move = false
var treePosition = Vector2()


func _physics_process(delta):
	if Input.is_action_just_pressed("BUTTON_LEFT") && Data.selected != null && activated == true && user == null:
		user = Data.selected
		user.changeActivity(self)
		Data.selected = null
		previous_user = user
		move = true

	if move == true:
		user.currentPos = user.position
		treePosition = position
		user.posToMove = treePosition - user.currentPos
		if not abs(user.posToMove.x) < 5 && not abs(user.posToMove.y) < 5:
			user.look_at(treePosition)
			user.velocity = user.posToMove.normalized() * user.speed
			user.move_and_slide(user.velocity, Vector2(0, 0))
			#user.move_and_collide(user.velocity * delta)
		else:
			move = false
	
	if user != null && is_generating == false && move == false:
		Events.emit_signal("new_ressources_generator", Events.RessourcesType.food, user)
		is_generating = true

	if user == null && is_generating == true:
		is_generating = false
		Events.emit_signal("delete_ressources_generator", Events.RessourcesType.food, previous_user)

func _on_Area2D_mouse_entered():
	activated = true

func _on_Area2D_mouse_exited():
	activated = false

func _on_XP_timeout():
	if user != null && is_generating == true:
		var floor_value = floor(user.woodcutter_level)
		user.woodcutter_level += 0.01/floor_value
		if floor(user.woodcutter_level) > floor_value:
			_on_user_levelup()
		print("niveau de bucheronnage : ", user.woodcutter_level)

func _on_user_levelup():
	Events.emit_signal("delete_ressources_generator", Events.RessourcesType.food, user)
	user.levelup_woodcutter()
	Events.emit_signal("new_ressources_generator", Events.RessourcesType.food, user)