extends Control

onready var soldier_container = $"TabContainer/Build Weapons/VBoxContainer/SoldierContainer"
onready var monsters_list = $"TabContainer/Stand By/VBoxContainer"

export (PackedScene) var ListMonsterBarrackUI

export (int) var initial_upgrade_cost = 50
var upgrade_cost = 50
var level = 1

var barrack
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(barrack_param):
	barrack = barrack_param
	rect_position = barrack_param.get_node("PositionUI").position
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	$TabContainer/Upgrade/UpgradeCostLabel.bbcode_text = str("cost :", upgrade_cost, " [img]res://assets/Graphics/Icon/Icon os ps25.png[/img]")
	soldier_container.init(self)
	
func reload_monster_list():
	for monster_info in monsters_list.get_children():
		monster_info.queue_free()
	for monster in barrack.monsters_stand_by:
		var list_monster_instance = ListMonsterBarrackUI.instance()
		list_monster_instance.init(monster, self)
		monsters_list.add_child(list_monster_instance)

func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= upgrade_cost:
			$TabContainer/Upgrade/ButtonUpgrade.disabled = false
		else:
			$TabContainer/Upgrade/ButtonUpgrade.disabled = true

func _on_weapon_created():
	barrack.create_weapon()
	
func is_weapon_available():
	return (barrack.number_of_weapon_possessed < barrack.max_weapon_quantity)
	
func on_monster_leave(monster):
	barrack.current_weapon_quantity += 1
	monster.changeActivity(null)
	monster.is_a_soldier = false
	reload_monster_list()
	
func on_monster_equipped(monster):
	monster.is_a_soldier = true

func _on_close_pressed():
	self.visible = false

func _on_TabContainer_tab_changed(tab: int):
	if tab == 1:
		reload_monster_list()


func _on_ButtonUpgrade_pressed():
	if barrack != null:
		Events.emit_signal("use_bones", upgrade_cost)
		level += 1
		upgrade_cost += initial_upgrade_cost
		$TabContainer/Upgrade/UpgradeCostLabel.bbcode_text = str("cost :", upgrade_cost, " [img]res://assets/Graphics/Icon/Icon os ps25.png[/img]")
		barrack.upgrade()
