extends Control

onready var research_list = $TabContainer/Research/VBoxContainer
onready var scientists_list = $TabContainer/Scientists

var DictionaryListUpgradesUI = {
	"wood_harvest" : preload("res://src/UI/ListUI/ListUpgradeUI/ListUpgradeWoodHarvestUI/UpgradeWoodHarvestList.tscn"),
	"bone_harvest" : preload("res://src/UI/ListUI/ListUpgradeUI/ListUpgradeBoneHarvest/UpgradeBoneHarvestList.tscn"),
	"max_number_soldier" : preload("res://src/UI/ListUI/ListUpgradeUI/ListUpgradeNbrSoldier/UpgradeNbrSoldertList.tscn")
}

export (PackedScene) var ListMonsterLabUI


var lab

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(lab_param):
	lab = lab_param
	rect_position = lab_param.get_node("PositionUI").position
	reload_upgrade_list()

func on_monster_leave(monster):
	monster.changeActivity(null)
	reload_monster_list()

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
		list_upgrade_instance.research_button.connect("pressed", self, "on_research_started", [Data.upgrades_type[upgrade_name]])
		list_upgrade_instance.init(Data.upgrade_levels[upgrade_name])

func on_research_started(type: int):
	if (type == Data.Upgrades.WOOD_HARVEST):
		pass
	elif (type == Data.Upgrades.BONE_HARVEST):
		pass
	elif (type == Data.Upgrades.NUMBER_SOLDIER):
		pass

func _on_close_pressed():
	self.visible = false


func _on_ButtonUpgrade_pressed():
	if lab != null:
		lab.upgrade()


func _on_TabContainer_tab_changed(tab: int):
	if tab == 1:
		reload_monster_list()
	if tab == 0:
		reload_upgrade_list()
