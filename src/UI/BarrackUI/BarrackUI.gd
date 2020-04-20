extends Control

onready var soldier_container = $"TabContainer/Build Weapons/VBoxContainer/SoldierContainer"
onready var monsters_list = $"TabContainer/Stand By/VBoxContainer"

export (PackedScene) var ListMonsterBarrackUI

var barrack
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(barrack_param):
	barrack = barrack_param
	rect_position = barrack_param.get_node("PositionUI").position
	soldier_container.init(self)
	
func reload_monster_list():
	for monster_info in monsters_list.get_children():
		monster_info.queue_free()
	for monster in barrack.monsters_stand_by:
		var list_monster_instance = ListMonsterBarrackUI.instance()
		list_monster_instance.init(monster, self)
		monsters_list.add_child(list_monster_instance)

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
