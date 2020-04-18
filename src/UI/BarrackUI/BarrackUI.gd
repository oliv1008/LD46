extends Control


onready var available_max_value_label = $"TabContainer/Build Weapons/VBoxContainer/HBoxContainer/AvailableMaxValue"
onready var build_button = $"TabContainer/Build Weapons/VBoxContainer/HBoxContainer/BuildButton"
var barrack
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(barrack_param):
	barrack = barrack_param
	rect_position = barrack_param.get_node("PositionUI").position


func _physics_process(delta):
	if barrack != null:
		available_max_value_label.text = str(barrack.current_weapon_quantity, " / ", barrack.max_weapon_quantity)
		
		if barrack.current_weapon_quantity >= barrack.max_weapon_quantity:
			build_button.disabled = true
		else:
			build_button.disabled = false

func _on_BuildButton_pressed():
	if barrack != null:
		barrack._on_Weapon_built(Events.WeaponChoices.SPEAR)


func _on_close_pressed():
	self.visible = false
