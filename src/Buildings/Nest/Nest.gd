tool
extends Node2D

onready var UI = $NestUI
var is_build: bool = false
var max_monsters_quantity = 2
var fuck_value = 0

var time_needed_to_procreate = 50
var actual_procreation = 0

var monsters_stand_by = []

export (int) var price_to_build = 1

export (PackedScene) var baby_monster

func _ready():
	$ButtonBuild.text = str("BUILD (", price_to_build, " bones)")
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	$Sprite2.modulate = Color(255, 255, 255, 1)
	$Sprite.self_modulate = Color(1, 1, 1, 0.5)

func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= price_to_build:
			$ButtonBuild.disabled = false
		else:
			$ButtonBuild.disabled = true

func _on_ButtonBuild_pressed():
	Events.emit_signal("use_bones", price_to_build)
	build()
	
func build():
	$Sprite.self_modulate = Color(1, 1, 1, 1)
	$ButtonBuild.visible = false
	is_build = true
	UI.init(self)

func upgrade():
	pass

func mate():
	if monsters_stand_by.size() == 2:
		Events.emit_signal("button_mate_pressed")
		if $Procreation.is_stopped():
			$Procreation.start()

func enter(user_param):
	user_param.isMoving = false
	monsters_stand_by.append(user_param)
	fuck_value += user_param.fucker_multiplier
	#user_param.position = Vector2(0, 0)
	user_param.visible = false
	user_param.get_node("Hitbox").disabled = true
	UI.reload_monster_list()

func leave(_user_param):
	if monsters_stand_by.size() == 2:
		$Procreation.stop()
	UI.mate_button.text = "MATE"
	UI.reload_monster_list()
	monsters_stand_by.remove(monsters_stand_by.find(_user_param))
	fuck_value -= _user_param.fucker_multiplier
	_user_param.position = $ExitPosition.global_position
	_user_param.visible = true
	_user_param.get_node("Hitbox").disabled = false

func on_monster_leave(user_param):
	UI.on_monster_leave(user_param)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (is_build && event is InputEventMouseButton && event.pressed):
		SoundManager.play_se("love_hotel.wav")
		if (Data.selected == null):
			UI.visible = true
		elif (monsters_stand_by.size() < max_monsters_quantity):
			Data.selected.changeActivity(self)
			Data.selected = null


func _on_Procreation_timeout():
	actual_procreation += fuck_value
	for monster in monsters_stand_by:
		var floor_value = floor(monster.fucker_level)
		monster.fucker_level += 0.01/floor_value
		if floor(monster.fucker_level) > floor_value:
			monster.levelup_fucker()
			fuck_value += 0.15
	if actual_procreation >= time_needed_to_procreate:
		var new_monster = baby_monster.instance()
		new_monster.position = $ExitPosition.global_position
		get_owner().add_child(new_monster)
		actual_procreation = 0
	UI.mate_button.text = str(actual_procreation, "/", time_needed_to_procreate)


func _on_Area2D_mouse_entered():
	$Sprite2.show()

func _on_Area2D_mouse_exited():
	$Sprite2.hide()
