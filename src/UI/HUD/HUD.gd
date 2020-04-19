extends Control

onready var number_food = $FoodNumber
onready var number_bone = $BoneNumber
onready var food_per_sec = $FoodPerSec
onready var bone_per_sec = $BonePerSec
onready var cost_per_sec = $CostPerSec

func _ready():
	$GottaEat.text = str("Your monster gotta eat ! That's why each of them consumes ", Data.food_needed_per_person, " per sec.")
	Events.connect("new_ressources_value", self, "change_ressources_value")
	Events.connect("new_ressources_per_sec_value", self, "change_ressources_per_sec_value")
	Events.connect("new_food_needed_per_tick", self, "change_food_needed_per_tick_value")


func change_ressources_value(type: int, value):
	if type == Events.RessourcesType.food:
		number_food.text = str(_format(value))
	if type == Events.RessourcesType.bone:
		number_bone.text = str(_format(value))
		
func change_ressources_per_sec_value(type: int, value):
	if type == Events.RessourcesType.food:
		food_per_sec.text = str("+",  value, " per sec")
	if type == Events.RessourcesType.bone:
		bone_per_sec.text = str("+",  value, " per sec")

func change_food_needed_per_tick_value(value):
	cost_per_sec.text = str("-",  value, " per sec")

func _format(value):
	if (value < 1000):
		return str(round(value))
	elif (value < 10000):
		return str(stepify(round(value)/1000,0.01)) + "K"
	elif (value < 100000):
		return str(stepify(round(value)/1000,0.1)) + "K"
	elif (value < 1000000):
		return str(stepify(round(value)/1000,1)) + "K"
	elif (value < 10000000):
		return str(stepify(round(value)/1000000,0.01)) + "M"
	elif (value < 100000000):
		return str(stepify(round(value)/1000000,0.1)) + "M"
	elif (value < 1000000000):
		return str(stepify(round(value)/1000000,1)) + "M"
	elif (value < 10000000000):
		return str(stepify(round(value)/1000000000,0.01)) + "G"
	elif (value < 100000000000):
		return str(stepify(round(value)/1000000000,0.1)) + "G"
	elif (value < 1000000000000):
		return str(stepify(round(value)/1000000000,1)) + "G"
	else:
		return "way too much"
