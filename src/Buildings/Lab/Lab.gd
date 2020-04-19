tool
extends Node2D

var world
onready var UI = $LabUI
var is_build: bool = false

var monsters_stand_by = []
var max_monsters_quantity = 1

var research_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	world = get_owner()
	$Sprite.self_modulate = Color(1, 1, 1, 0.5)

func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= 0:
			$ButtonBuild.disabled = false
		else:
			$ButtonBuild.disabled = true

func upgrade():
	pass
	
func _on_Research():
	pass
	
func enter(user_param):
	monsters_stand_by.append(user_param)
	research_value += 0.25 + (0.5 * user_param.scientist_level) 
	user_param.visible = false

func leave(_user_param):
	monsters_stand_by.remove(monsters_stand_by.find(_user_param))
	research_value -= 0.25 + (0.5 * _user_param.scientist_level) 
	_user_param.visible = true

func _on_ButtonBuild_pressed():
	$Sprite.self_modulate = Color(1, 1, 1, 1)
	$ButtonBuild.visible = false
	is_build = true
	UI.init(self)
	
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (is_build && event is InputEventMouseButton && event.pressed):
		if (Data.selected == null):
			UI.visible = true
		
		elif (monsters_stand_by.size() < max_monsters_quantity):
			Data.selected.changeActivity(self)
			Data.selected = null
