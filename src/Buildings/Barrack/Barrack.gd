tool
extends Node2D

onready var UI = $BarrackUI
var is_build: bool = false

var monsters_stand_by = []
var max_monsters_quantity = 1

var max_weapon_quantity: int = 2
var current_weapon_quantity: int = 0
var number_of_weapon_possessed: int = 0

export (int) var price_to_build = 1
var ameliorated_sprite = preload("res://assets/Graphics/batiments/caserne update.png")

func _ready():
	$ButtonBuild.text = str("BUILD (", price_to_build, " bones)")
	$Sprite2.modulate = Color(255, 255, 255, 1)
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	Events.connect("ennemy_spawned", self, "go_battle")
	Events.connect("no_more_ennemies", self, "go_home")
	$Sprite.self_modulate = Color(1, 1, 1, 0.5)

func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= price_to_build:
			$ButtonBuild.disabled = false
		else:
			$ButtonBuild.disabled = true

func enter(user_param):
	user_param.is_a_soldier = true
	user_param.pos_casern = $ExitPosition.global_position
	monsters_stand_by.append(user_param)
	#user_param.position = Vector2(0, 0)
	user_param.get_node("Hitbox").disabled = true
	user_param.visible = false
	UI.reload_monster_list()
	if Data.ennemy_list.size() != 0:
		user_param.position = $ExitPosition.global_position
		user_param.visible = true
		user_param.isMoving = true
		user_param.combat = false

func leave(_user_param):
	monsters_stand_by.remove(monsters_stand_by.find(_user_param))
	_user_param.position = $ExitPosition.global_position
	_user_param.visible = true
	_user_param.get_node("Hitbox").disabled = false

func go_battle():
	var compteur = 0
	SoundManager.play_se("caserne_et_au_combat.wav")
	SoundManager.set_se_volume_db(SoundManager.get_se_volume_db()-10)
	for monster in monsters_stand_by:
		if compteur == 0:
			monster.position = $ExitPosition.global_position
		if compteur == 1:
			monster.position = $ExitPosition2.global_position
		if compteur == 2:
			monster.position = $ExitPosition2.global_position
		monster.visible = true
		monster.isMoving = true
		monster.combat = false
		monster.isAttacking = false
		monster.get_node("Hitbox").disabled = false
		compteur += 1

func go_home():
	for monster in monsters_stand_by:
		monster.get_node("AnimatedSprite").rotation_degrees = 0
		monster.go_to_casern = true

func upgrade():
	max_weapon_quantity += 1
	$Sprite.texture = ameliorated_sprite
	$Sprite2.texture = ameliorated_sprite

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
	
func create_weapon():
	current_weapon_quantity += 1
	number_of_weapon_possessed += 1

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (is_build && event is InputEventMouseButton && event.pressed):
		SoundManager.play_se("caserne_et_au_combat.wav")
		SoundManager.set_se_volume_db(SoundManager.get_se_volume_db()-10)
		if (Data.selected == null):
			UI.visible = true
		
		elif (monsters_stand_by.size() < number_of_weapon_possessed):
			Data.selected.changeActivity(self)
			current_weapon_quantity -= 1
			Data.selected = null


func _on_Area2D_mouse_entered():
	$Sprite2.show()

func _on_Area2D_mouse_exited():
	$Sprite2.hide()
