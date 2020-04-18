extends Control

onready var research1_button = $TabContainer/ScrollContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button
onready var research2_button = $TabContainer/ScrollContainer/VBoxContainer/HBoxContainer2/VBoxContainer/Button
var lab

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(lab_param):
	lab = lab_param
	rect_position = lab_param.get_node("PositionUI").position


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
