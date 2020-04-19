tool
extends Node2D

onready var UI = $BarrackUI
var is_build: bool = false

var monsters_stand_by = []
var max_monsters_quantity = 1

var max_weapon_quantity: int = 2
var current_weapon_quantity: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	$Sprite.self_modulate = Color(1, 1, 1, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= 1:
			$ButtonBuild.disabled = false
		else:
			$ButtonBuild.disabled = true

func enter(user_param):
	monsters_stand_by.append(user_param)
	user_param.position = Vector2(0, 0)
	user_param.visible = false
	UI.reload_monster_list()

func leave(_user_param):
	monsters_stand_by.remove(monsters_stand_by.find(_user_param))
	_user_param.position = $ExitPosition.global_position
	_user_param.visible = true


func _on_ButtonBuild_pressed():
	$Sprite.self_modulate = Color(1, 1, 1, 1)
	$ButtonBuild.visible = false
	is_build = true
	UI.init(self)
	
func create_soldier():
	current_weapon_quantity += 1

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (is_build && event is InputEventMouseButton && event.pressed):
		if (Data.selected == null):
			UI.visible = true
		
		elif (monsters_stand_by.size() < max_monsters_quantity):
			Data.selected.changeActivity(self)
			Data.selected = null
