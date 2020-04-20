extends Node2D

var user 
var is_generating = false
var bonePosition = Vector2()
var bone1 = load("res://assets/Graphics/batiments/os 25.png")
var bone2 = load("res://assets/Graphics/batiments/os 25 2.png")
var bones_sprites = [bone1, bone2]

var is_build = false

export (int) var price_to_build = 1

signal bone_built

func _ready():
	randomize()
	$Sprite.texture = bones_sprites[randi() % bones_sprites.size()] 
	$Sprite2.texture = $Sprite.texture
	$Sprite2.modulate = Color(255,255,255,0.5)
	$ButtonBuild.text = str("BUILD (", price_to_build, " bones)")
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	
func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= price_to_build:
			$ButtonBuild.disabled = false
		else:
			$ButtonBuild.disabled = true
	
func enter(user_param):
	if is_generating == false:
		user = user_param
		Events.emit_signal("new_ressources_generator", Events.RessourcesType.bone, user_param)
		is_generating = true

func on_monster_leave(user_param):
	user.changeActivity(null)

func leave(_user_param):
	is_generating = false
	Events.emit_signal("delete_ressources_generator", Events.RessourcesType.bone, user)
	user = null

func _on_XP_timeout():
	if user != null && is_generating == true:
		var floor_value = floor(user.miner_level)
		user.miner_level += 0.01/floor_value
		if floor(user.miner_level) > floor_value:
			_on_user_levelup()
			
func _on_user_levelup():
	Events.emit_signal("delete_ressources_generator", Events.RessourcesType.bone, user)
	user.levelup_miner()
	Events.emit_signal("new_ressources_generator", Events.RessourcesType.bone, user)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (is_build && event is InputEventMouseButton && event.pressed):
		SoundManager.play_se("Mining.ogg")
		$Stop_effect.start()
		if (Data.selected == null && user != null):
			Data.selected = user
			pass
		elif (Data.selected != null && user == null):
			Data.selected.changeActivity(self)
			Data.selected = null
		
		
func _on_Area2D_mouse_entered():
	$Sprite2.show() 

func _on_Area2D_mouse_exited():
	$Sprite2.hide()


func _on_Stop_effect_timeout():
	SoundManager.stop_se("Mining.ogg")

func _on_ButtonBuild_pressed():
	Events.emit_signal("use_bones", price_to_build)
	build()

func build():
	$Sprite.self_modulate = Color(1, 1, 1, 1)
	$ButtonBuild.visible = false
	is_build = true
	emit_signal("bone_built")
