extends Control

onready var research_list = $TabContainer/Research/VBoxContainer
onready var scientists_list = $TabContainer/Scientists/VBoxContainer

export (int) var initial_upgrade_cost = 50
var upgrade_cost = 50
var level = 1


var DictionaryListUpgradesUI = {
	"wood_harvest" : preload("res://src/UI/ListUI/ListUpgradeUI/ListUpgradeWoodHarvestUI/UpgradeWoodHarvestList.tscn"),
	"bone_harvest" : preload("res://src/UI/ListUI/ListUpgradeUI/ListUpgradeBoneHarvest/UpgradeBoneHarvestList.tscn"),
	"max_number_soldier" : preload("res://src/UI/ListUI/ListUpgradeUI/ListUpgradeNbrSoldier/UpgradeNbrSoldertList.tscn")
}

export (PackedScene) var ListMonsterLabUI

var upgrading
var lab
var actual_research_cost

var actual_research = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(lab_param):
	lab = lab_param
	rect_position = lab_param.get_node("PositionUI").position
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	$TabContainer/Upgrade/UpgradeCostLabel.bbcode_text = str("cost :", upgrade_cost, " [img]res://assets/Graphics/Icon/Icon os ps25.png[/img]")
	reload_upgrade_list()

func on_monster_leave(monster):
	monster.changeActivity(null)
	reload_monster_list()

func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= upgrade_cost:
			$TabContainer/Upgrade/ButtonUpgrade.disabled = false
		else:
			$TabContainer/Upgrade/ButtonUpgrade.disabled = true

func reload_monster_list():
	for monster_info in scientists_list.get_children():
		monster_info.queue_free()
	for monster in lab.monsters_stand_by:
		var list_monster_instance = ListMonsterLabUI.instance()
		list_monster_instance.init(monster, self)
		scientists_list.add_child(list_monster_instance)
		
func reload_upgrade_list():
	for upgrade_info in research_list.get_children():
		upgrade_info.queue_free()

	var upgrade_names = DictionaryListUpgradesUI.keys();
	for upgrade_name in upgrade_names: 
		var list_upgrade_instance = DictionaryListUpgradesUI[upgrade_name].instance()
		research_list.add_child(list_upgrade_instance)
		list_upgrade_instance.connect("upgrade_selected", self, "on_research_started")
		list_upgrade_instance.init(Data.upgrade_levels[upgrade_name])

func on_research_started(type: int, upgrade):
	Events.emit_signal("disable_lab_button")
	upgrading = upgrade
	if (type == Data.Upgrades.WOOD_HARVEST):
		actual_research_cost = upgrading.research_cost
		Events.emit_signal("use_bones", upgrading.cost)
		Events.emit_signal("new_research", upgrading.get_node("VBoxContainer").get_node("TextureRect").texture)
		$ResearchingWoodHarvest.start()
	elif (type == Data.Upgrades.BONE_HARVEST):
		actual_research_cost = upgrading.research_cost
		Events.emit_signal("use_bones", upgrading.cost)
		Events.emit_signal("new_research", upgrading.get_node("VBoxContainer").get_node("TextureRect").texture)
		$ResearchingBoneHarvest.start()
	elif (type == Data.Upgrades.NUMBER_SOLDIER):
		actual_research_cost = upgrading.research_cost
		Events.emit_signal("use_bones", upgrading.cost)
		Events.emit_signal("new_research", upgrading.get_node("VBoxContainer").get_node("TextureRect").texture)
		$ResearchingSoldierDmg.start()

func _on_close_pressed():
	self.visible = false

func _on_ButtonUpgrade_pressed():
	if lab != null:
		Events.emit_signal("use_bones", upgrade_cost)
		level += 1
		upgrade_cost += initial_upgrade_cost
		$TabContainer/Upgrade/UpgradeCostLabel.bbcode_text = str("cost :", upgrade_cost, " [img]res://assets/Graphics/Icon/Icon os ps25.png[/img]")
		lab.upgrade()

func _on_TabContainer_tab_changed(tab: int):
	if tab == 1:
		reload_monster_list()
	if tab == 0:
		reload_upgrade_list()


func _on_ResearchingWoodHarvest_timeout():
	actual_research += lab.research_value
	for monster in lab.monsters_stand_by:
		var floor_value = floor(monster.scientist_level)
		monster.scientist_level += 0.01/floor_value
		if floor(monster.scientist_level) > floor_value:
			monster.levelup_scientist()
			lab.research_value += 0.15
	if actual_research >= actual_research_cost:
		Data.food_harvest_speed += 0.10
		Data.upgrade_levels["wood_harvest"] += 1
		actual_research = 0
		$ResearchingWoodHarvest.stop()
		Events.emit_signal("enable_lab_button")
		Events.emit_signal("end_research")
		Events.emit_signal("refresh_per_tick", Events.RessourcesType.food)
		reload_upgrade_list()
	Events.emit_signal("new_research_state", actual_research, actual_research_cost)

func _on_ResearchingBoneHarvest_timeout():
	actual_research += lab.research_value
	for monster in lab.monsters_stand_by:
		var floor_value = floor(monster.scientist_level)
		monster.scientist_level += 0.01/floor_value
		if floor(monster.scientist_level) > floor_value:
			monster.levelup_scientist()
			lab.research_value += 0.15
	if actual_research >= actual_research_cost:
		Data.bone_harvest_speed += 0.10
		Data.upgrade_levels["bone_harvest"] += 1
		actual_research = 0
		$ResearchingBoneHarvest.stop()
		Events.emit_signal("enable_lab_button")
		Events.emit_signal("end_research")
		Events.emit_signal("refresh_per_tick", Events.RessourcesType.bone)
		reload_upgrade_list()
	Events.emit_signal("new_research_state", actual_research, actual_research_cost)

func _on_ResearchingSoldierDmg_timeout():
	actual_research += lab.research_value
	for monster in lab.monsters_stand_by:
		var floor_value = floor(monster.scientist_level)
		monster.scientist_level += 0.01/floor_value
		if floor(monster.scientist_level) > floor_value:
			monster.levelup_scientist()
			lab.research_value += 0.15
	if actual_research >= actual_research_cost:
		Data.soldier_damage += 0.10
		Data.upgrade_levels["max_number_soldier"] += 1
		actual_research = 0
		$ResearchingSoldierDmg.stop()
		Events.emit_signal("enable_lab_button")
		Events.emit_signal("end_research")
		reload_upgrade_list()
	Events.emit_signal("new_research_state", actual_research, actual_research_cost)
