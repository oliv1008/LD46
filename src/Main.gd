extends Node2D

var foods = 0
var bones = 0

var food_per_tick = 0
var bone_per_tick = 0

onready var lab = $Lab

func _ready():
	Events.connect("new_ressources_generator", self, "add_ressources_per_tick")
	Events.connect("delete_ressources_generator", self, "delete_ressources_per_tick") 

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

func _on_FoodTimer_timeout():
	foods += food_per_tick
	if food_per_tick > 0:
		Events.emit_signal("new_ressources_value", Events.RessourcesType.food, foods)

func _on_MaterialTimer_timeout():
	bones += bone_per_tick
	if bone_per_tick > 0:
		Events.emit_signal("new_ressources_value", Events.RessourcesType.bone, bones)
