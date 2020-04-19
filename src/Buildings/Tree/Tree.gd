extends Node2D

var user = null
var is_generating = false
var treePosition = Vector2()

#func _physics_process(delta):	
	
func enter(user_param):
	if is_generating == false:
		user = user_param
		Events.emit_signal("new_ressources_generator", Events.RessourcesType.food, user_param)
		is_generating = true
	
func leave(_user_param):
	is_generating = false
	Events.emit_signal("delete_ressources_generator", Events.RessourcesType.food, user)
	user = null

func _on_XP_timeout():
	if user != null && is_generating == true:
		var floor_value = floor(user.woodcutter_level)
		user.woodcutter_level += 0.01/floor_value
		if floor(user.woodcutter_level) > floor_value:
			_on_user_levelup()

func _on_user_levelup():
	Events.emit_signal("delete_ressources_generator", Events.RessourcesType.food, user)
	user.levelup_woodcutter()
	Events.emit_signal("new_ressources_generator", Events.RessourcesType.food, user)


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if (Data.selected == null && user != null):
			#shoot up UI
			pass
		elif (Data.selected != null && user == null):
			Data.selected.changeActivity(self)
			Data.selected = null
