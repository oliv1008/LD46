extends Control

onready var research1_button = $TabContainer/ScrollContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button
onready var research2_button = $TabContainer/ScrollContainer/VBoxContainer/HBoxContainer2/VBoxContainer/Button

onready var scientists_list = $TabContainer/ScientistsContainer

export (PackedScene) var ListMonsterLabUI

var lab

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(lab_param):
	lab = lab_param
	rect_position = lab_param.get_node("PositionUI").position

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

func _physics_process(delta):
	if lab != null:
		pass

func _on_Research1():
	pass
	
func _on_Research2():
	pass

func _on_close_pressed():
	self.visible = false


func _on_ButtonUpgrade_pressed():
	if lab != null:
		lab.upgrade()


func _on_TabContainer_tab_changed(tab: int):
	if tab == 1:
		reload_monster_list()
