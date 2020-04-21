extends Node

var selected 
var monster_list = []
var ennemy_list = []
var food_needed_per_person = 0.5
var food_harvest_speed = 1
var bone_harvest_speed = 1
var soldier_damage = 1

var lab_button_disabling = false

var upgrade_levels = {
	"wood_harvest" : 1,
	"bone_harvest" : 1,
	"max_number_soldier" : 1
}

enum Upgrades {WOOD_HARVEST, BONE_HARVEST, NUMBER_SOLDIER}
var upgrades_type = {
	"wood_harvest" : Upgrades.WOOD_HARVEST,
	"bone_harvest" : Upgrades.BONE_HARVEST,
	"max_number_soldier" : Upgrades.NUMBER_SOLDIER
}

