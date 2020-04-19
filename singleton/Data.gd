extends Node

var selected 
var monster_list = []

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

