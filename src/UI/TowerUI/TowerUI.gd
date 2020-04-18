extends Control

onready var upgrade_button = $ButtonUpgrade
var tower

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(tower_param):
	tower = tower_param
	rect_position = tower_param.get_node("PositionUI").position


func _physics_process(delta):
	if tower != null:
		pass


func _on_BuildButton_pressed():
	if tower != null:
		tower.upgrade()


func _on_close_pressed():
	self.visible = false


func _on_ButtonUpgrade_pressed():
	pass # Replace with function body.
