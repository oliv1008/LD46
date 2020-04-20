extends Node2D

var foods = 0
var bones = 0

var food_per_tick = 0
var bone_per_tick = 0

var food_needed_per_tick = 1
var food_needed_per_person = 0.5

onready var lab = $Lab

func _ready():
	SoundManager.play_bgm("Animal crossing.wav")
	Events.connect("new_ressources_generator", self, "add_ressources_per_tick")
	Events.connect("delete_ressources_generator", self, "delete_ressources_per_tick") 
	Events.connect("new_monster", self, "on_new_monster")
	Events.connect("monster_death", self, "on_monster_death")
	Events.connect("use_bones", self, "on_use_bones")

func add_ressources_per_tick(type: int, user):
	if (type == Events.RessourcesType.food):
		food_per_tick += 1*user.woodcutter_multiplier
		Events.emit_signal("new_ressources_per_sec_value", Events.RessourcesType.food, food_per_tick)
	if (type == Events.RessourcesType.bone):
		bone_per_tick += 1*user.miner_multiplier
		Events.emit_signal("new_ressources_per_sec_value", Events.RessourcesType.bone, bone_per_tick)

func delete_ressources_per_tick(type: int, user):
	if (type == Events.RessourcesType.food):
		food_per_tick -= 1*user.woodcutter_multiplier
		Events.emit_signal("new_ressources_per_sec_value", Events.RessourcesType.food, food_per_tick)
	if (type == Events.RessourcesType.bone):
		bone_per_tick -= 1*user.miner_multiplier
		Events.emit_signal("new_ressources_per_sec_value", Events.RessourcesType.bone, bone_per_tick)

func on_new_monster():
	print("nouveau monstre !")
	food_needed_per_tick += food_needed_per_person
	Events.emit_signal("new_food_needed_per_tick", food_needed_per_tick)
	
func on_monster_death():
	food_needed_per_tick -= food_needed_per_person
	Events.emit_signal("new_food_needed_per_tick", food_needed_per_tick)

func _on_FoodTimer_timeout():
	foods += food_per_tick*Data.food_harvest_speed
	if food_per_tick > 0:
		Events.emit_signal("new_ressources_value", Events.RessourcesType.food, foods)

func _on_MaterialTimer_timeout():
	bones += bone_per_tick*Data.bone_harvest_speed
	if bone_per_tick > 0:
		Events.emit_signal("new_ressources_value", Events.RessourcesType.bone, bones)

func _on_HpDecay_timeout():
	if foods < food_needed_per_tick:
		Events.emit_signal("losing_hp")
	else:
		foods -= food_needed_per_tick
		Events.emit_signal("new_ressources_value", Events.RessourcesType.food, foods)
	
func on_use_bones(value):
	bones -= value
	Events.emit_signal("new_ressources_value", Events.RessourcesType.bone, bones)
