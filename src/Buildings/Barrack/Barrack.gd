tool
extends Node2D

onready var UI = $"BarrackUI"
var is_build: bool = false

var monsters_stand_by = []

var max_weapon_quantity: int = 1
var current_weapon_quantity: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.self_modulate = Color(1, 1, 1, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonBuild_pressed():
	$Sprite.self_modulate = Color(1, 1, 1, 1)
	$ButtonBuild.visible = false
	is_build = true
	
func _on_Weapon_built(type):
	current_weapon_quantity += 1


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (is_build && event is InputEventMouseButton && event.pressed):
		UI.init(self)
		UI.visible = true
		pass
