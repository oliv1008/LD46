extends Control

onready var mate_button = $ButtonMate
var nest

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(nest_param):
	nest = nest_param
	rect_position = nest_param.get_node("PositionUI").position


func _physics_process(delta):
	if nest != null:
		pass


func _on_BuildButton_pressed():
	if nest != null:
		nest.mate()


func _on_close_pressed():
	self.visible = false
