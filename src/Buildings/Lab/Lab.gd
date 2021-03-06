tool
extends Node2D

onready var UI = $LabUI
var is_build: bool = false

var monsters_stand_by = []
var max_monsters_quantity = 1

var research_value = 0
var ameliorated_sprite = preload("res://assets/Graphics/batiments/laboratoire upgrade.png")

export (int) var price_to_build = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$ButtonBuild.text = str("BUILD (", price_to_build, " bones)")
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	$Sprite2.modulate = Color(255,255,255, 0.5)
	$Sprite.self_modulate = Color(1, 1, 1, 0.5)

func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= price_to_build:
			$ButtonBuild.disabled = false
		else:
			$ButtonBuild.disabled = true

func upgrade():
	max_monsters_quantity += 1
	$Sprite.texture = ameliorated_sprite
	$Sprite2.texture = ameliorated_sprite
	
func enter(user_param):
	monsters_stand_by.append(user_param)
	research_value += user_param.scientist_multiplier
	#user_param.position = Vector2(0, 0)
	user_param.visible = false
	user_param.get_node("Hitbox").disabled = false
	UI.reload_monster_list()

func leave(_user_param):
	monsters_stand_by.remove(monsters_stand_by.find(_user_param))
	research_value -= _user_param.scientist_multiplier

	_user_param.position = $ExitPosition.global_position
	_user_param.visible = true
	_user_param.get_node("Hitbox").disabled = false

func on_monster_leave(user_param):
	UI.on_monster_leave(user_param)

func _on_ButtonBuild_pressed():
	Events.emit_signal("use_bones", price_to_build)
	build()
	
func build():
	$Sprite.self_modulate = Color(1, 1, 1, 1)
	$ButtonBuild.visible = false
	is_build = true
	UI.init(self)
	
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (is_build && event is InputEventMouseButton && event.pressed):
		SoundManager.play_se("lab_sound.wav")
		if (Data.selected == null):
			UI.visible = true
		
		elif (monsters_stand_by.size() < max_monsters_quantity):
			Data.selected.changeActivity(self)
			Data.selected = null


func _on_Area2D_mouse_entered():
	$Sprite2.show()


func _on_Area2D_mouse_exited():
	$Sprite2.hide()
