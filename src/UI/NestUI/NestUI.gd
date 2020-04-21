extends Control

onready var mate_button = $ButtonMate
var nest

onready var fucker_list = $FuckersContainer

var ListMonsterNestUI = preload("res://src/UI/ListUI/ListMonsterNestUI/ListMonsterNestUI.tscn")

func _ready():
	pass # Replace with function body.
	
func init(nest_param):
	nest = nest_param
	rect_position = nest_param.get_node("PositionUI").position

func on_monster_leave(monster):
	monster.changeActivity(null)
	reload_monster_list()

func reload_monster_list():
	for monster_info in fucker_list.get_children():
		monster_info.queue_free()
	for monster in nest.monsters_stand_by:
		var list_monster_instance = ListMonsterNestUI.instance()
		list_monster_instance.init(monster, self)
		fucker_list.add_child(list_monster_instance)

func _physics_process(delta):
	if nest != null:
		pass

func _on_BuildButton_pressed():
	if nest != null:
		nest.mate()


func _on_close_pressed():
	self.visible = false

func _on_ButtonMate_pressed():
	nest.mate()
	
